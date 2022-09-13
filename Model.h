#ifndef MODEL_H
#define MODEL_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QTimer>
class Model : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QJsonDocument jsonData READ getJsonData WRITE setJsonData RESET
                   resetJsonData NOTIFY jsonDataChanged)
    Q_PROPERTY(QByteArray plainJsonData READ getPlainJsonData WRITE setPlainJsonData NOTIFY plainJsonDataChanged)
public:
  explicit Model(QObject *parent = nullptr);

  const QJsonDocument &getJsonData() const;
  void setJsonData(const QJsonDocument &newJsonData);
  void resetJsonData();

  const QByteArray &getPlainJsonData() const;
  void setPlainJsonData(const QByteArray &newPlainJsonData);

signals:
  void jsonDataChanged();
  void plainJsonDataChanged();




private:
  QTimer *TestJsonTimer = new QTimer(this);
  int count;
  QJsonDocument jsonData;
  QByteArray plainJsonData;

public slots:
  QString jsonTester();
  void addObject(void);
  void change_Rotation();
//  QString getPlainJsonData();
};

#endif // MODEL_H
