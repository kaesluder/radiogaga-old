import sys
from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication, QLabel
from pyradios import RadioBrowser
from PySide6.QtWidgets import QApplication, QTableWidget, QTableWidgetItem


def radio_browser_name_search(name):
    rb = RadioBrowser()
    return rb.search(name=name, name_exact=False)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    table = QTableWidget()
    search_results = radio_browser_name_search("soma")
    print(search_results)
    table.setRowCount(len(search_results))
    table.setColumnCount(4)
    for i, record in enumerate(search_results):
        table.setItem(i, 0, QTableWidgetItem(record["name"]))
        table.setItem(i, 1, QTableWidgetItem(record["codec"]))
        table.setItem(i, 2, QTableWidgetItem(str(record["bitrate"])))
        table.setItem(i, 3, QTableWidgetItem(record["language"]))

    table.show()

    sys.exit(app.exec())
