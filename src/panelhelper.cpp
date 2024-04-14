#include "panelhelper.h"
#include "applicationhandler.h"

#include <KWindowSystem>
#include <NETWM>
#include <QDebug>
#include <QX11Info>

static const QStringList blockList = {"dde-launchpad", "top-panel", "dde-dock"};

PanelHelper *PanelHelper::m_instance = nullptr;

PanelHelper::PanelHelper(QObject *parent)
    : QObject(parent)
    , m_appHandler(ApplicationHandler::instance())
{
    connect(KWindowSystem::self(),
            &KWindowSystem::activeWindowChanged,
            this,
            &PanelHelper::onActiveWindowChanged);
    connect(KWindowSystem::self(),
            static_cast<void (
                KWindowSystem::*)(WId id, NET::Properties properties, NET::Properties2 properties2)>(
                &KWindowSystem::windowChanged),
            this,
            &PanelHelper::onActiveWindowChanged);
}

QString PanelHelper::getTitle() const
{
    return m_title;
}

QString PanelHelper::getIcon() const
{
    return m_icon;
}

void PanelHelper::onActiveWindowChanged()
{
    auto info = KWindowInfo(KWindowSystem::activeWindow(),
                     NET::WMState | NET::WMVisibleName | NET::WMWindowType | NET::WMIconName,
                     NET::WM2WindowClass | NET::WM2DesktopFileName);

    bool titleHasChanged = false;
    bool iconCHashanged = false;

    if (NET::typeMatchesMask(info.windowType(NET::AllTypesMask), NET::DesktopMask)) {
        m_title = tr("Desktop");
        m_icon = "";
        titleHasChanged = true;
        iconCHashanged = true;
    } else if (isAcceptableWindow(KWindowSystem::activeWindow())
        && !blockList.contains(info.windowClassClass())) {

        m_pid = info.pid();
        m_windowClass = info.windowClassClass().toLower();

        QString title = info.name();
        if (title != m_title) {
            m_title = title;
            titleHasChanged = true;
        }
        // 获取进程名作为图标名
        QString icon = m_appHandler->getPNameFromPid(m_pid);
        if (icon != m_icon) {
            m_icon = icon;
            iconCHashanged = true;
        }
        qDebug() << "pic: " << m_pid <<  " title: " << title << " icon: " << icon;
    }

    if (titleHasChanged) {
        emit titleChanged();
    }
    if (iconCHashanged) {
        emit iconChanged();
    }
}

bool PanelHelper::isAcceptableWindow(quint64 wid)
{
    QFlags<NET::WindowTypeMask> ignoreList;
    ignoreList |= NET::DesktopMask;
    ignoreList |= NET::DockMask;
    ignoreList |= NET::SplashMask;
    ignoreList |= NET::ToolbarMask;
    ignoreList |= NET::MenuMask;
    ignoreList |= NET::PopupMenuMask;
    ignoreList |= NET::NotificationMask;

    KWindowInfo info(wid,
                     NET::WMWindowType | NET::WMState,
                     NET::WM2TransientFor | NET::WM2WindowClass);

    if (!info.valid())
        return false;

    if (NET::typeMatchesMask(info.windowType(NET::AllTypesMask), ignoreList))
        return false;

    if (info.hasState(NET::SkipTaskbar) || info.hasState(NET::SkipPager))
        return false;

    WId transFor = info.transientFor();
    if (transFor == 0 || transFor == wid || transFor == (WId) QX11Info::appRootWindow())
        return true;

    info = KWindowInfo(transFor, NET::WMWindowType);

    QFlags<NET::WindowTypeMask> normalFlag;
    normalFlag |= NET::NormalMask;
    normalFlag |= NET::DialogMask;
    normalFlag |= NET::UtilityMask;

    return !NET::typeMatchesMask(info.windowType(NET::AllTypesMask), normalFlag);
}

PanelHelper *PanelHelper::instance()
{
    if (!m_instance)
        m_instance = new PanelHelper();
    return m_instance;
}
