all: clean report.csv send

clean:
	@rm -f *.csv *.xls

report.csv:
	@echo "Формирую отчёт.."
	@./report.rb

report.xls:
	@echo "Конвертирую в xls"
	@ssconvert  --import-encoding=utf-8 report.csv report.xls 

send:
	@echo "Полный отчёт за все периоды" | \
		mutt -s "Отчёт о проделанных и проделываемых работах в разработке" -a report.xls -- ${MAIL}
	@echo "Отправлено на ${MAIL}"
