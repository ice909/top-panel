#ifndef PANEL_H
#define PANEL_H

#include <QQuickView>

class Panel : public QQuickView
{
    Q_OBJECT
public:
    explicit Panel(QQuickView *parent = nullptr);
    // 更新窗口坐标
    void updateGeometry();
    // 保留屏幕顶部的空间
    void updateViewStruts();

};

#endif // PANEL_H