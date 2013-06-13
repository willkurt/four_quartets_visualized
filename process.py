import re
import csv


def process():
    quartet_title_pattern = "==(.+)=="
    stanza_title_pattern = "__(.+)__"
    quartet_title = "None"
    stanza_title = "None"
    with open('four_quartets.txt','r') as f:
        with open('four_quartets.csv','w') as edt:
            csv_writer = csv.writer(edt)
            csv_writer.writerow(["quartet","stanza","line"])
            for l in f:
				#if matches ==.*==
				#   set quartet title
				if re.search(quartet_title_pattern,l):
					m = re.match(quartet_title_pattern,l)
					quartet_title = m.group(1)
					print(quartet_title)
				#if matches __.*__
				#    set stanza title
				elif re.search(stanza_title_pattern,l):
					m = re.match(stanza_title_pattern,l)
					stanza_title = m.group(1)
					print(stanza_title)
				#quick check for 'not a blank line'
				elif re.search("[a-zA-Z0-9]",l):
					clean_line = l.strip()
					print(clean_line)
					csv_writer.writerow([quartet_title,stanza_title,clean_line])
				else:
					print("blank!")
                #

if __name__ == "__main__":
    process()