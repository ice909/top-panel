#include "applicationhandler.h"

#include <QStringList>
#include <QFile>
#include <QIODevice>

ApplicationHandler *ApplicationHandler::m_instance = nullptr;

ApplicationHandler::ApplicationHandler(QObject *parent)
    : QObject(parent)
{
}

ApplicationHandler *ApplicationHandler::instance()
{
    if (!m_instance) {
        m_instance = new ApplicationHandler();
    }
    return m_instance;
}


QString ApplicationHandler::getPNameFromPid(const int &pid){
    // 先拿到进程的名称
    QFile file(QString("/proc/%1/cmdline").arg(pid));

    if (file.open(QIODevice::ReadOnly)) {
        QByteArray cmd = file.readAll();
        if (!cmd.isEmpty()) {
            int zeroIndex = cmd.indexOf('\0');
            int processNameStart = cmd.lastIndexOf('/', zeroIndex);
            if (processNameStart == -1) {
                processNameStart = 0;
            } else {
                processNameStart++;
            }

            QString name = QString::fromLocal8Bit(cmd.mid(processNameStart, zeroIndex - processNameStart));

            name = name.split(' ').first();
            return name;
        }
    }
}
