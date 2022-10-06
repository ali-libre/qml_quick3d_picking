#include "Model.h"
//#include <Q
Model::Model(QObject *parent) : QObject{parent} {
    connect(TestJsonTimer, &QTimer::timeout, this, &Model::change_Rotation);
    TestJsonTimer->start(40);
    readHFM("/home/minoosa/Documents/Robot Test Fountain.hfm");
    update_model();
}

const QJsonDocument &Model::getJsonData() const {
    //    qDebug() << jsonData.toJson ();
    //    return jsonData;
//    resultmodel.setObject (jObjFountain);
    QJsonDocument resultmodel(jObjFountain);
    return resultmodel;
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

bool Model::readHFM(QString path) {
    QJsonObject obj;
    path.remove("file://");
    obj = file2Jobj(path);
    QString fountainName = obj["Fountain Name"].toString();
    if(!fountainName.size ())
        return false;
    if (obj.isEmpty())
        return false;
    jObjFountain = obj;
    return true;
}

QJsonObject Model::loadJsonObject(QString title, QString extention) {
    QJsonObject obj;
    //    QString loadPath =
    //        File->getOpenFileName(NULL, title, documentPath, extention);
    //    obj = file2Jobj(loadPath);
    return obj;
}

QJsonObject Model::file2Jobj(QString f) {
    QJsonObject obj;
    QFile file(f);
    //    file.remove("file://");
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Could Not Open File...";
        return obj;
    }
    QByteArray inputProject = file.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(inputProject));
    obj = loadDoc.object();
    file.close();
    return obj;
}

void Model::update_model() {
    //    QJsonArray JArrayGroups;
    QJsonArray nozzelList;
    //    JArrayGroups = jObjFountain["Group"].toArray();

    int groupY = -500;
    for (auto jagrp : jObjFountain["Group"].toArray()) {
        QJsonObject jObjGroup = jagrp.toObject();
        QJsonArray jArrayNozzel = jObjGroup["Nozzles"].toArray();
        int groupX = -1000;
        for (auto nzl : jArrayNozzel) {
            QJsonObject jObjNozzel = nzl.toObject();
            QJsonArray jArrayLED = jObjNozzel["LED List"].toArray();
            QJsonArray jArrayPump = jObjNozzel["Pump List"].toArray();
            QJsonArray jArrayRobot = jObjNozzel["Robot List"].toArray();
            QJsonArray tempNozzel;
            //            if (jArrayLED.count() > jArrayPump.count())
            for (auto jaled : jArrayLED) {
                QJsonObject jObjLED = jaled.toObject();
                QJsonObject Nozzel;
                Nozzel["NID"] = jObjLED["NID"];
                Nozzel["GID"] = jObjGroup["ID"];
                Nozzel["x"] = groupX;
                Nozzel["y"] = groupY;
                Nozzel["z"] = 0;
                Nozzel["pump"] = 200;
                Nozzel["rX"] = 0;
                Nozzel["rY"] = 0;
                Nozzel["rZ"] = 0;
                Nozzel["color"] = "#FF0000";
                nozzelMerge(Nozzel, jObjLED, "L");
                tempNozzel.append(Nozzel);
                groupX += 100;
            }

            // Pump Handle
            if(jArrayPump.count())
            if (jArrayPump.count() < jArrayLED.count()) {
                for (auto tnozzel : tempNozzel) {
                    QJsonObject obj = tnozzel.toObject();
                    tnozzel = nozzelMerge(obj, jArrayPump[0].toObject(), "P");
                }
            } else if (jArrayPump.count() == jArrayLED.count()) {
                int Loop = 0;
                for (auto tnozzel : tempNozzel) {
                    QJsonObject obj = tnozzel.toObject();
                    tnozzel =
                        nozzelMerge(obj, jArrayPump[Loop++].toObject(), "P");
                }
            }

            // Robot Handle
            if(jArrayRobot.count())
            if (jArrayRobot.count() < jArrayLED.count()) {
                for (auto tnozzel : tempNozzel) {
                    QJsonObject obj = tnozzel.toObject();
                    tnozzel = nozzelMerge(obj, jArrayRobot[0].toObject(), "R");
                }
            } else if (jArrayRobot.count() == jArrayLED.count()) {
                int Loop = 0;
                for (auto tnozzel : tempNozzel) {
                    QJsonObject obj = tnozzel.toObject();
                    tnozzel =
                        nozzelMerge(obj, jArrayRobot[Loop++].toObject(), "R");
                }
            }
            groupX += 100;

            // fill array
            for (auto tNozzel : tempNozzel)
                nozzelList.append(tNozzel.toObject());
        }
        groupY += 200;
    }
//        for (auto tnozzel : nozzelList) {
//            QJsonObject obj = tnozzel.toObject();
//            obj["rX"] = 0;
//            obj["rY"] = 0;
//            obj["rZ"] = 0;
//        }
    qDebug() << nozzelList;
    QJsonObject testSubobj;
    testSubobj["nozzle"] = nozzelList;
    jObj3DMap["test"] = testSubobj;
    jObj3DMap["nozzle"] = nozzelList;
}

QJsonObject Model::nozzelMerge(QJsonObject mergeItem, QJsonObject inputItem, QString appenditem) {
    QJsonObject out;
    mergeItem[appenditem + id] = inputItem[id];
    mergeItem[appenditem + dmx] = inputItem[dmx];
    mergeItem[appenditem + universe] = inputItem[universe];
    return mergeItem;
}

QString Model::jsonTester() {
//    qDebug() << "test";
//    return jsonData.toJson ();
    QJsonDocument resultmodel(jObj3DMap);
    return resultmodel.toJson ();
}

QString Model::jsontreeTester() {
    //    qDebug() << "test";
    //    return jsonData.toJson ();
    QJsonDocument resultmodel(jObjFountain);
    return resultmodel.toJson ();
}

void Model::change_Rotation() {
    static int rx = 0;
    QJsonObject query(jsonData.object());
    QJsonObject Property;
    QJsonArray jArr(query["nozzle"].toArray());

    //    Property["rZ"] = 500;
    rx += 3;
    if (rx > 90)
        rx = -90;
    for (int Loop = 0; Loop < jArr.count (); Loop++) {
        Property = jArr[Loop].toObject();
        if(Loop % 2)
            Property["rX"] = rx;
        else
            Property["rX"] = -rx;
        jArr[Loop] = Property;
    }
    query["nozzle"] = jArr;
    jsonData.setObject(query);
}


