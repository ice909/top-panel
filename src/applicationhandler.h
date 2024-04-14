#ifndef APPLICATION_HANDLER_H
#define APPLICATION_HANDLER_H

#include <QObject>

class ApplicationHandler : public QObject
{
    Q_OBJECT

public:
    static ApplicationHandler *instance();
    explicit ApplicationHandler(QObject *parent = nullptr);
    // 通过进程号获取进程名
    QString getPNameFromPid(const int &pid);

private:
    static ApplicationHandler *m_instance;
};

#endif // APPLICATION_HANDLER_H