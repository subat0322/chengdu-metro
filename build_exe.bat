@echo off
python -m pip install pyinstaller --quiet
pyinstaller --onefile --name "ChengduMetro" --add-data "templates;templates" --add-data "static;static" --add-data "station_coords_new.json;." --hidden-import flask --hidden-import waitress metro_app.py
echo Done: dist\ChengduMetro.exe
pause
