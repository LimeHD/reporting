MAIL=danil@brandymint.ru

all: clean report.csv send

clean:
	@rm -f ./report.csv

report.csv:
	@echo "Формирую отчёт.."
	@./report.rb

send:
	@echo "Полный отчёт за все периоды" | \
		mutt -s "Отчёт о проделанных и проделываемых работах в разработке" -a report.csv -- danil@brandymint.ru
	@echo "Отправлено на ${MAIL}"
