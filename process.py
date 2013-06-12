import re
import csv


def process():
    quartet_title_pattern = "==(.+)=="
    verse_title_pattern = "__(.+)__"
    quartet_title = "None"
    verse_title = "None"
    with open('four_quartets.txt','r') as f:
        with open('four_quartets.csv','w') as edt:
            csv_writer = csv.writer(edt)
            csv_writer.writerow(["quartet","verse","line"])
            for l in f:
				#if matches ==.*==
				#   set quartet title
				if re.search(quartet_title_pattern,l):
					m = re.match(quartet_title_pattern,l)
					quartet_title = m.group(1)
					print(quartet_title)
				#if matches __.*__
				#    set verse title
				elif re.search(verse_title_pattern,l):
					m = re.match(verse_title_pattern,l)
					verse_title = m.group(1)
					print(verse_title)
				#quick check for 'not a blank line'
				elif re.search("[a-zA-Z0-9]",l):
					clean_line = l.strip()
					print(clean_line)
					csv_writer.writerow([quartet_title,verse_title,clean_line])
				else:
					print("blank!")
                #

if __name__ == "__main__":
    process()