This `bash` script should be able to automatically download all the individual
loan agreements from your portfolio at the peer-to-peer lending platform
Grupeer. It runs outside a web browser but needs to be manually passed a session
cookie. A browser is needed to log in and obtain the cookie.

## Usage
Log in to the Grupeer website from your browser like you normally would and keep
this window open until the script finishes running. Look
for the `laravel_session` cookie in your browser. It should be a long string
of alphanumeric characters. How exactly to do this depends on your browser. Copy
the content of the cookie and pass it as the first argument to this script
like such:
```
./download_grupeer_agreements.sh eyJpdiI6Ijk5UUJjK2Z5NFh5dmcrRTVTaUpYY1E9PSIsInZhbHVlIjoidWtEa2s4ZnduYjlNQXhndFV2WDI0OHRzYm9QZVIyS2cxbHFZMUp1VUQxZ01HMWxpaTl5bHl2NWhwWW1BT0VwTHpNUWE3eUdRYlBiWXg2c3U3cThUTUE9PSIsIm1hYyI6IjljZDc5NmU3MDNiOWRhNTE4OGRhZmExZGY4NGEwMjEwOTc4NGFiNjY0ZDc5NjIyOWE0MDliMzYyOGNkNWEwZTcifQ
```

The script obtains a list of all agreements and sequentially downloads them
to the current directory. An individual download request may sometimes fail
because of CloudFlare/Grupeer's DDos protection. Every file is checked and
looped over until it succeeds. It seems that refreshing your browser can help
the scripted requests go through. After the download is done, make sure that
the total number of downloaded files matches your expectation.

## Requirements
This script was written in and tested on a GNU/Linux environment. It uses
the common Unix tools `bash`, `curl`, `expr`, `file`, `grep`, `mv`, and `xargs`.
A test on macOS revealed that the `-r` option to `xargs` is GNU-specific and is
not available on that system. It is not essential and can be removed
from the script by simply changing `-rL` to `-L`. Keep in mind that without this
option, the script may get stuck in an infinite loop if trying to obtain
the list of agreements does not result in a single entry. That for example
happens when the session cookie is invalid.

## Pairing with loan IDs
You can download a spreadsheet called `Investments.xlsx` from the Grupeer
website that includes all your current and past investments. This spreadsheet is
sorted by date of purchase. If you sort the list of the downloaded PDF files
numerically, it should match the order in the spreadsheet. This list can then be
pasted as another column in the spreadsheet to pair the investments with their
respective agreements. You should save this in a separate file and keep
the original file exactly as it was exported from the website as it may be
required for other automatic processes. To obtain the sorted list, do:
```
ls *.pdf | sort -n
```

### Renaming files
If you want to include loan IDs directly in the file names of the downloaded
agreements, you can use the `add_loan_ids.sh` script. Take the list of loan IDs
from the first column of `Investments.xlsx` and save it to a plain text file.
If you have saved the list to `loan_ids.lst`, run the script like this:
```
./add_loan_ids.sh loan_ids.lst
```

This will attempt to rename all files in the current directory ending in `.pdf`
so make sure that the directory does not contain other PDF files. The script
uses the technique described above to correlate loan IDs with agreement IDs.
You should still check the result manually to be sure.
