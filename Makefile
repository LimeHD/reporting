MAIL=danil@brandymint.ru

all: clean report.csv send

clean:
	@rm -f ./report.csv

report.csv:
	@echo "Формирую отчёт.."
	@./report.rb

send:
	@iconv -c -f utf-8 -t cp1251 -o ./report_cp1251.csv ./report.csv
	@echo "Полный отчёт за все периоды" | \
		mutt -s "Отчёт о проделанных и проделываемых работах в разработке" -a report_cp1251.csv -- ${MAIL}
	@echo "Отправлено на ${MAIL}"
