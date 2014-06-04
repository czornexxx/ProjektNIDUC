@echo off

cd Projekt

rd/s/q Debug
del Projekt.sdf
cd Projekt
rd/s/q Debug

cd ..
cd ..


"H:\Program Files (x86)\Git\bin\sh.exe" --login -i
