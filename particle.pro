QT += quick quick3d

target.path = $$[QT_INSTALL_EXAMPLES]/quick3d/picking
INSTALLS += target

SOURCES += \
    Model.cpp \
    main.cpp

RESOURCES += \
    qml.qrc \
    materials.qrc

OTHER_FILES += \
    doc/src/*.*

HEADERS += \
    Model.h