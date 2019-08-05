QT += core
QT -= gui

TARGET = sample_SSD
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

QMAKE_CXXFLAGS += -std=c++11 -g

INCLUDEPATH += /usr/src/tensorrt/samples/common

INCLUDEPATH += /usr/include/aarch64-linux-gnu

INCLUDEPATH +=/usr/include/opencv\
              /usr/include/opencv2
LIBS += /usr/lib/libopencv_*.so


LIBS += -L/usr/lib  -lglog -lgflags -lprotobuf -lleveldb -lsnappy -llmdb -lboost_system  -lm   -lboost_thread -lstdc++  -lprotobuf  -lcblas -latlas
LIBS += -L/usr/lib/aarch64-linux-gnu   -lnvcaffe_parser  -lnvinfer  -lnvinfer_plugin  -lnvparsers

INCLUDEPATH +=/usr/include/python2.7/
#INCLUDEPATH +=/usr/include/
INCLUDEPATH +=/usr/local/include/
LIBS += -lboost_python -lpython2.7 -lboost_system


SOURCES += sampleSSD.cpp

LIBS += -pthread

#CUDA_SOURCES +=  cudaNormalize.cu \
#    cudaOverlay.cu \
#    cudaResize.cu \
#    cudaRGB.cu \
#    cudaYUV-NV12.cu \
#    cudaYUV-YUYV.cu \
#    cudaYUV-YV12.cu \
#    kernel.cu \
#    mathFunctions.cu
# CUDA settings <-- may change depending on your system
CUDA_SDK = "/usr/local/cuda-10.0"   # Path to cuda SDK install
CUDA_DIR = "/usr/local/cuda-10.0"            # Path to cuda toolkit install

# DO NOT EDIT BEYOND THIS UNLESS YOU KNOW WHAT YOU ARE DOING....

SYSTEM_NAME = unix         # Depending on your system either 'Win32', 'x64', or 'Win64'
SYSTEM_TYPE = 64           # '32' or '64', depending on your system
CUDA_ARCH = compute_62          # Type of CUDA architecture, for example 'compute_10', 'compute_11', 'sm_10'
NVCC_OPTIONS = --use_fast_math


# include paths
INCLUDEPATH += $$CUDA_DIR/include

# library directories
QMAKE_LIBDIR += $$CUDA_DIR/lib64/

CUDA_OBJECTS_DIR = ./

# CUDA settings <-- may change depending on your system



# Add the necessary libraries
CUDA_LIBS = -lcuda -lcudart

# The following makes sure all path names (which often include spaces) are put between quotation marks
CUDA_INC = $$join(INCLUDEPATH,'" -I"','-I"','"')
#LIBS += $$join(CUDA_LIBS,'.so ', '', '.so')
LIBS += $$CUDA_LIBS

# Configuration of the Cuda compiler
CONFIG(debug, debug|release) {
    # Debug mode
    cuda_d.input = CUDA_SOURCES
    cuda_d.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.o
    cuda_d.commands = $$CUDA_DIR/bin/nvcc -D_DEBUG $$NVCC_OPTIONS $$CUDA_INC $$NVCC_LIBS --machine $$SYSTEM_TYPE -arch=$$CUDA_ARCH -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME}
    cuda_d.dependency_type = TYPE_C
    QMAKE_EXTRA_COMPILERS += cuda_d
}
else {
    # Release mode
    cuda.input = CUDA_SOURCES
    cuda.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.o
    cuda.commands = $$CUDA_DIR/bin/nvcc $$NVCC_OPTIONS $$CUDA_INC $$NVCC_LIBS --machine $$SYSTEM_TYPE -arch=$$CUDA_ARCH -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME}
    cuda.dependency_type = TYPE_C
    QMAKE_EXTRA_COMPILERS += cuda
}


DEFINES += QT_DEPRECATED_WARNINGS
