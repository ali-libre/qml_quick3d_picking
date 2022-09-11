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
public:
  explicit Model(QObject *parent = nullptr);

  const QJsonDocument &getJsonData() const;
  void setJsonData(const QJsonDocument &newJsonData);
  void resetJsonData();

signals:
  void jsonDataChanged();



private:
  QTimer *TestJsonTimer = new QTimer(this);

  int count;
  QJsonDocument jsonData;
  Q_PROPERTY(QJsonDocument jsonData READ getJsonData WRITE setJsonData RESET
                 resetJsonData NOTIFY jsonDataChanged)
public slots:
  QByteArray jsonTester();
  QString getPlainJsonData();
};

#endif // MODEL_H
