#ifndef PANEL_HELPER_H
#define PANEL_HELPER_H

#include <QObject>

class ApplicationHandler;
class PanelHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ getTitle NOTIFY titleChanged)
    Q_PROPERTY(QString icon READ getIcon NOTIFY iconChanged)
public:
    static PanelHelper *instance();
    QString getTitle() const;
    QString getIcon() const;
signals:
    void titleChanged();
    void iconChanged();
    void activeWindowChanged(const int &id, const QString &title);

public slots:
    void close();

private slots:
    void onActiveWindowChanged();

private:
    PanelHelper(QObject *parent = nullptr);
    bool isAcceptableWindow(quint64 wid);

private:
    static PanelHelper *m_instance;
    ApplicationHandler *m_appHandler;
    quint32 m_pid = 0;
    QString m_windowClass;
    QString m_title;
    QString m_icon;
};

#endif // PANEL_HELPER_H