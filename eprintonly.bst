ENTRY
  { author
    title
    year
    note
    eprint
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }
INTEGERS { nameptr numnames namesleft }
STRINGS { s t }

FUNCTION {init.state}
{ before.all 'output.state := }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
          write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
  { namesleft #0 > }
  { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=
    nameptr #1 >
      { namesleft #1 >
          { ", " * t * }
          { numnames #2 >
              { ", and " * t * }
              { " and " * t * }
            if$
          }
        if$
      }
      { t }
    if$
    nameptr #1 + 'nameptr :=
    namesleft #1 - 'namesleft :=
  }
  while$
}

FUNCTION {format.author}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title }
  if$
}

FUNCTION {format.eprint}
{ eprint empty$
    { "" }
    { "\href{https://arxiv.org/abs/" eprint * "}{\path{arXiv:" * eprint * "}}" * }
  if$
}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{1}" write$ newline$
}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

FUNCTION {article}
{ "\bibitem{" cite$ * "}" * write$ newline$
  format.author ". " * write$
  format.title ". " * write$
  format.eprint empty$
    'skip$
    { format.eprint ", " * write$ }
  if$
  note empty$
    'skip$
    { note ". " * write$ }
  if$
  year write$
  "." write$
  newline$
}

FUNCTION {book} { article }
FUNCTION {inbook} { article }
FUNCTION {incollection} { article }
FUNCTION {inproceedings} { article }
FUNCTION {conference} { article }
FUNCTION {manual} { article }
FUNCTION {mastersthesis} { article }
FUNCTION {misc} { article }
FUNCTION {phdthesis} { article }
FUNCTION {proceedings} { article }
FUNCTION {techreport} { article }
FUNCTION {unpublished} { article }

READ

EXECUTE {begin.bib}
ITERATE {call.type$}
EXECUTE {end.bib}
