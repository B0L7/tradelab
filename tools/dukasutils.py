import csv
from datetime import datetime
from datetime import timedelta
import matplotlib.dates as dt

def dukas_read_bars(fname):
    #col_types = [float, float, float, float, float]
    data = []

    try:
        with open(fname) as f:
            f_csv = csv.reader(f)
            headers = next(f_csv)
            for row in f_csv:
                #data.append((dt.date2num(datetime.strptime(row[0], '%Y.%m.%d %H:%M:%S')),) + tuple(convert(value) for convert, value in zip(col_types, row[1:])))
                #data.append((dt.date2num(datetime.strptime(row[0], '%Y.%m.%d %H:%M:%S')),) + tuple(float(value) for value in row[1:]))
                record = dt.date2num(datetime.strptime(row[0], '%Y.%m.%d %H:%M:%S')), float(row[1]), float(row[4]), float(row[2]), float(row[3])
                data.append(record)

    except FileNotFoundError:
        print('Sorry, your file was not found')

    return(data)



def genquotes():
    """Generating a sample sequence of bars for chart testing purposes"""
    #b_open, b_close, b_high, b_low = 100, 105, 110, 95
    b_open, b_close, b_high, b_low = 95, 100, 105, 90
    quotes = []

    #drawing an uptrend of 25 candles
    start_date = datetime.strptime('2010.01.01', '%Y.%m.%d')
    for i in range(0,25):
        b_open, b_close, b_high, b_low = b_open + 5, b_close + 5, b_high + 5, b_low + 5
        row = dt.date2num(start_date), b_open, b_close, b_high, b_low
        quotes.append(row)
        start_date += timedelta(days=1)

    #drawing a downtrend of 25 candles
    b_open, b_close, b_high, b_low = b_close, b_open, b_high, b_low
    for i in range(0,25):
        row = dt.date2num(start_date), b_open, b_close, b_high, b_low
        quotes.append(row)
        start_date += timedelta(days=1)
        b_open, b_close, b_high, b_low = b_open - 5, b_close - 5, b_high - 5, b_low - 5

    return(quotes)


        

