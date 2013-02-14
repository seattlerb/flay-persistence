= flay-persistence

home :: https://github.com/seattlerb/flay-persistence
rdoc :: http://docs.seattlerb.org/flay-persistence

== DESCRIPTION:

Did you ever want to make your flay results persistent?!? Me neither,
but now you can! This flay plugin allows you to run flay across
multiple runs combining and persisting the results. This allows you to
detect plagiarism or good gem candidates across multiple projects.

== FEATURES/PROBLEMS:

* Adds -p flag to persist data on a file-by-file basis.
* Adds -r flag to re-run against already scanned files.
* Currently uses Marshal to persist... This begs for maglev.

== SYNOPSIS:

  % flay -p some_project
  % flay -p -r other_project # redo already scanned files with -r
  % flay -p                  # just show the persisted data

== REQUIREMENTS:

* flay 2.1+

== INSTALL:

* sudo gem install flay-persistence

== LICENSE:

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
