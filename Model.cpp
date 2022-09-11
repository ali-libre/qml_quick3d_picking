#include "Model.h"
//#include <Q
Model::Model(QObject *parent) : QObject{parent} {
    connect(TestJsonTimer, &QTimer::timeout, this, &Model::jsonTester);
//    TestJsonTimer->start(500);
    QJsonObject property;
    QJsonObject query;

    QJsonArray jArr;
    for (int Loop = 0; Loop < 10; Loop++) {
        property["x"] = 200 * Loop;
        property["y"] = 0;
        property["z"] = 0;
        jArr.append(property);
    }
    //    test["position"] =
    query["nozzle"] = jArr;
    jsonData.setObject (query);
}

const QJsonDocument &Model::getJsonData() const {
//    qDebug() << jsonData.toJson ();
    return jsonData;
}

QString Model::getPlainJsonData() {
//    qDebug() << jsonData.toJson ();
    return jsonData.toJson ();
}

void Model::setJsonData(const QJsonDocument &newJsonData) {
    if (jsonData == newJsonData)
        return;
    jsonData = newJsonData;
    emit jsonDataChanged();
}

void Model::resetJsonData() {
    setJsonData({}); // TODO: Adapt to use your actual default value
}

QByteArray Model::jsonTester() {
//    qDebug() << "test";
    return jsonData.toJson ();
}
