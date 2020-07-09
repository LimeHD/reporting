all: report send

clean:
	@rm -f *.csv *.xls

report.csv:
	@echo "Формирую отчёт.."
	@./report.rb

report.xls:
	@echo "Конвертирую в xls"
	@ssconvert --import-type=Gnumeric_stf:stf_csvtab --import-encoding=utf-8 report.csv report.xls 

report: clean report.csv report.xls

send:
	@echo "Отчёт за прошлый месяц" | \
		mutt -s "Отчёт о проделанных и проделываемых работах в разработке" -a report.xls -- ${MAIL}
	@echo "Отправлено на ${MAIL}"
