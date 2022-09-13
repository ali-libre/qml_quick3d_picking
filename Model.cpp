#include "Model.h"
//#include <Q
Model::Model(QObject *parent) : QObject{parent} {
    connect(TestJsonTimer, &QTimer::timeout, this, &Model::change_Rotation);
    TestJsonTimer->start(200);
    QJsonObject property;
    QJsonObject query;
//    QJsonObject LED;


    QJsonArray jArr;
    for (int Loop = 0; Loop < 10; Loop++) {
        property["x"] = 200 * Loop;
        property["y"] = 0;
        property["z"] = 0;
        property["pump"] = 200;
        property["rX"] = 0;
        property["rY"] = 0;
        property["rZ"] = 0;

//        LED["LED"] = property;
//        jArr.append(LED);
        jArr.append(property);
    }
    //    test["position"] =
    query["nozzle"] = jArr;
    jsonData.setObject(query);
    //    for (int Loop = 0; Loop < 10; Loop++) {
    //        addObject();
    //    }
//    qDebug() << jsonData.toJson();

}

const QJsonDocument &Model::getJsonData() const {
//    qDebug() << jsonData.toJson ();
    return jsonData;
}

//QString Model::getPlainJsonData() {
////    qDebug() << jsonData.toJson ();
//    return jsonData.toJson ();
//}

void Model::setJsonData(const QJsonDocument &newJsonData) {
    if (jsonData == newJsonData)
        return;
    jsonData = newJsonData;
    emit jsonDataChanged();
    emit plainJsonDataChanged();
}

void Model::resetJsonData() {
    setJsonData({}); // TODO: Adapt to use your actual default value
}

const QByteArray &Model::getPlainJsonData() const
{
    return plainJsonData;
}

void Model::setPlainJsonData(const QByteArray &newPlainJsonData)
{
    if (plainJsonData == newPlainJsonData)
        return;
    plainJsonData = newPlainJsonData;
    emit plainJsonDataChanged();
}

QString Model::jsonTester() {
//    qDebug() << "test";
    return jsonData.toJson ();
}

void Model::addObject() {
    static int y = 0;
    qDebug() << jsonTester();
    QJsonObject query(jsonData.object());
    QJsonObject Property;
    QJsonArray jArr(query["nozzle"].toArray());
    Property["x"] = 0;
    Property["y"] = y;
    y += 200;
    qDebug() << " Y is:" << y;
    Property["z"] = 0;
    jArr.append(Property);
    query["nozzle"] = jArr;
    jsonData.setObject(query);
}

void Model::change_Rotation() {
    static int rx = 0;
    QJsonObject query(jsonData.object());
    QJsonObject Property;
    QJsonArray jArr(query["nozzle"].toArray());
    Property = jArr[0].toObject();
    Property["rX"] = rx;
//    Property["rZ"] = 500;
    rx += 10;
    if (rx > 90)
        rx = -90;
    //    Property["x"] = 0;
    //    Property["y"] = y;
    //    y += 200;
    //    qDebug() << " Y is:" << y;
    //    Property["z"] = 0;
    //    jArr.append(Property);
    jArr[0] = Property;
    query["nozzle"] = jArr;
    jsonData.setObject(query);
}
