#ifndef MODEL_H
#define MODEL_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QTimer>

#include <QFileDialog>

#include <QStandardPaths>


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

  QJsonObject nozzelMerge(QJsonObject mergeItem, QJsonObject inputItem, QString appenditem);
  signals:
  void jsonDataChanged();
  void plainJsonDataChanged();




private:
  QTimer *TestJsonTimer = new QTimer(this);
  int count;
  QJsonDocument jsonData;
  QByteArray plainJsonData;
  QString documentPath =
      QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
  QJsonObject loadJsonObject(QString title, QString extention);
  //  QFileDialog *File = new QFileDialog();

  QJsonObject file2Jobj(QString f);
  void update_model();

  QJsonObject jObjFountain;
  QJsonObject jObj3DMap;
  QString id = "ID";
  QString dmx = "DMX";
  QString universe = "Universe";

public slots:
  QString jsonTester();
  QString jsontreeTester();
//  void addObject(void);
  void change_Rotation();
  bool readHFM(QString path);
//  QString getPlainJsonData();
};

#endif // MODEL_H
