#include "panel.h"
#include "panelhelper.h"

#include <QApplication>
#include <QScreen>
#include <QRect>
#include <QQmlEngine>
#include <QQmlContext>
#include <NETWM>
#include <KWindowSystem>
#include <KWindowEffects>

#define PANEL_HEIGHT 25

Panel::Panel(QQuickView *parent)
    : QQuickView(parent)
{
    setFlags(Qt::FramelessWindowHint | Qt::WindowDoesNotAcceptFocus);
    setColor(Qt::transparent);

    KWindowSystem::setOnDesktop(winId(), NET::OnAllDesktops);
    KWindowSystem::setType(winId(), NET::Dock);

    engine()->rootContext()->setContextProperty("PanelHelper", PanelHelper::instance());

    setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    setResizeMode(QQuickView::SizeRootObjectToView);
    setScreen(qApp->primaryScreen());
    updateGeometry();
    // 使窗口背景模糊
    KWindowEffects::enableBlurBehind(winId(), true);
    // 使窗口保持在最上层
    KWindowSystem::setState(winId(), NET::KeepAbove);

    setVisible(true);
}

void Panel::updateGeometry()
{
    const QRect rect = screen()->geometry();

    QRect windowRect = QRect(rect.x(), rect.y(), rect.width(), PANEL_HEIGHT);
    setGeometry(windowRect);
    updateViewStruts();
}

void Panel::updateViewStruts()
{
    const QRect rect = geometry();

    NETExtendedStrut strut;
    strut.top_width = rect.height() + 1;
    strut.top_start = rect.x();
    strut.top_end = rect.x() + rect.width();

    KWindowSystem::setExtendedStrut(winId(),
                                 strut.left_width,
                                 strut.left_start,
                                 strut.left_end,
                                 strut.right_width,
                                 strut.right_start,
                                 strut.right_end,
                                 strut.top_width,
                                 strut.top_start,
                                 strut.top_end,
                                 strut.bottom_width,
                                 strut.bottom_start,
                                 strut.bottom_end);
}