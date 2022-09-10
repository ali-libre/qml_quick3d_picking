#include "Model.h"
//#include <Q
Model::Model(QObject *parent) : QObject{parent} {
    connect(TestJsonTimer, &QTimer::timeout, this, &Model::jsonTester);
//    TestJsonTimer->start(500);
    QJsonObject test;
    QJsonArray jArr;
    for (int Loop = 0; Loop < 10; Loop++) {
        test["x"] = 200 * Loop;
        test["y"] = 0;
        test["z"] = 0;
        jArr.append(test);
    }
    //    test["position"] =
    jsonData.setArray (jArr);
}

const QJsonDocument &Model::getJsonData() const {
    qDebug() << jsonData.toJson ();
    return jsonData;
}

QByteArray Model::getPlainJsonData() {
    qDebug() << jsonData.toJson ();
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

void Model::jsonTester() { qDebug() << "test";
}
