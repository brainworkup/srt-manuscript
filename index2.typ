// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text(size: 0.92em)
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%, 0%), end: (75%, 0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it
    .children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
    ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
  fill: luma(230),
  width: 100%,
  inset: 8pt,
  radius: 2pt,
)

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }
}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
        kind: kind,
        supplement: supplement,
        caption: caption,
        {
          show figure.where(kind: kind): set figure(
            numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1),
          )
          show figure.where(kind: kind): set figure.caption(position: position)

          show figure: it => {
            let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
            show figure.caption: it => {
              num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
              [ ]
              it.body
            }

            quartosubfloatcounter.step()
            it
            counter(figure.where(kind: it.kind)).update(n => n - 1)
          }

          quartosubfloatcounter.update(0)
          body
        },
      )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block,
    block_with_new_content(
      old_title_block.body,
      old_title_block.body.body.children.at(0) + old_title_block.body.body.children.at(1) + new_title,
    ),
  )

  block_with_new_content(
    old_callout,
    block(below: 0pt, new_title_block) + old_callout.body.children.at(1),
  )
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false,
    fill: background_color,
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"),
    width: 100%,
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%,
      below: 0pt,
      block(
        fill: background_color,
        width: 100%,
        inset: 8pt,
      )[#text(icon_color, weight: 900)[#icon] #title],
    )
      + if (body != []) {
        block(
          inset: 1pt,
          width: 100%,
          block(fill: white, width: 100%, inset: 8pt, body),
        )
      },
  )
}

#let simple_function(x) = [
  Some text with #x
]

#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "linux libertine",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "linux libertine",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
  )
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
        #set par(leading: heading-line-height)
        #if (
          heading-family != none
            or heading-weight != "bold"
            or heading-style != "normal"
            or heading-color != black
            or heading-decoration == "underline"
            or heading-background-color != none
        ) {
          set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
          text(size: title-size)[#title]
          if subtitle != none {
            parbreak()
            text(size: subtitle-size)[#subtitle]
          }
        } else {
          text(weight: "bold", size: title-size)[#title]
          if subtitle != none {
            parbreak()
            text(weight: "bold", size: subtitle-size)[#subtitle]
          }
        }
      ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author => align(center)[
        #author.name \
        #author.affiliation \
        #author.email
      ])
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
        #date
      ]]
  }

  if abstract != none {
    block(inset: 2em)[
      #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
      #outline(
        title: toc_title,
        depth: toc_depth,
        indent: toc_indent,
      );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none,
)

#show: doc => article(
  title: [Using Quarto to Generate Documents in APA Style (7th Edition)],
  authors: (
    (name: [Ana Fulano], affiliation: [Ana and Blanca's University], email: [sm\@example.org]),
    (name: [Blanca Zutano], affiliation: [Ana and Blanca's University], email: []),
    (name: [Carina Mengano], affiliation: [Carina's Primary Affiliation, Carina's Secondary Affiliation], email: []),
    (name: [true], affiliation: [], email: []),
  ),
  lang: "en",
  abstract: [This document is a template demonstrating the apaquarto format.],
  abstract-title: "Abstract",
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

This is my introductory paragraph. The title will be placed above it automatically. #emph[Do not start with an introductory heading] (e.g., "Introduction"). The title acts as your Level 1 heading for the introduction.

Details about writing headings with markdown in APA style are #link("https://wjschne.github.io/apaquarto/writing.html#headings-in-apa-style")[here];.

== Displaying Figures
<displaying-figures>
A reference label for a figure must have the prefix `fig-`, and in a code chunk, the caption must be set with `fig-cap`. Captions are in #link("https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case")[title case];.

#figure(
  [
    #box(image("index_files/figure-typst/fig-myplot-1.svg"))
  ],
  caption: figure.caption(
    position: bottom,
    [
      The Figure Caption
    ],
  ),
  kind: "quarto-float-fig",
  supplement: "Figure",
)
<fig-myplot>


To refer to any figure or table, use the `@` symbol followed by the reference label (e.g., #ref(<fig-myplot>, supplement: [Figure])).

== Imported Graphics
<imported-graphics>
One way to import an existing graphic as a figure is to use `knitr::include_graphics` in a code chunk. For example, #ref(<fig-import1>, supplement: [Figure]) is an imported image. Note that in apaquarto-pdf documents, we can specify that that a figure or table should span both columns when in journal mode by setting the `apa-twocolumn` chunk option to `true`. For other formats, this distinction does not matter.

#figure(
  [
    #box(image("sampleimage.png", width: 48%))
  ],
  caption: figure.caption(
    position: bottom,
    [
      An Imported Graphic
    ],
  ),
  kind: "quarto-float-fig",
  supplement: "Figure",
)
<fig-import1>


Figure graphics can be imported directly with Markdown, as with #ref(<fig-import2>, supplement: [Figure]).

#figure(
  [
    #box(image("sampleimage.png", width: 49%))
  ],
  caption: figure.caption(
    position: bottom,
    [
      Another Way to Import Graphics
    ],
  ),
  kind: "quarto-float-fig",
  supplement: "Figure",
)
<fig-import2>


Which style of creating figures you choose depends on preference and need.

== Displaying Tables
<displaying-tables>
We can make a table the same way as a figure. Generating a table that conforms to APA format in all document formats can be tricky. When the table is simple, the `kable` function from knitr works well. Feel free to experiment with different methods, but I have found that David Gohel's #link("https://davidgohel.github.io/flextable/")[flextable] to be the best option when I need something more complex.

#figure(
  [
    #table(
      columns: 2,
      align: (right, left),
      table.header([Numbers], [Letters]),
      table.hline(),
      [1], [A],
      [2], [B],
      [3], [C],
      [4], [D],
    )
  ],
  caption: figure.caption(
    position: top,
    [
      The Table Caption
    ],
  ),
  kind: "quarto-float-tbl",
  supplement: "Table",
)
<tbl-mytable>


To refer to this table in text, use the `@` symbol followed by the reference label like so: As seen in #ref(<tbl-mytable>, supplement: [Table]), the first few numbers and letters of the alphabet are displayed.

In #ref(<tbl-mymarkdowntable>, supplement: [Table]), there is an example of a plain markdown table with a note below it.

#figure(
  [
    #table(
      columns: 4,
      align: (auto, left, right, center),
      table.header([Default], [Left], [Right], [Center]),
      table.hline(),
      [12], [12], [12], [12],
      [123], [123], [123], [123],
      [1], [1], [1], [1],
    )
  ],
  caption: figure.caption(
    position: top,
    [
      Table Caption of a Markdown Table
    ],
  ),
  kind: "quarto-float-tbl",
  supplement: "Table",
)
<tbl-mymarkdowntable>


What if you want the tables and figures to be at the end of the document? In the .pdf format, you can set the `floatsintext` option to false. For .html and .docx documents, there is not yet an automatic way to put tables and figures at the end. You can, of course, just put them all at the end, in order. The reference labels will work no matter where they are in the text.

== Tables and Figures Spanning Two Columns in Journal Mode
<tables-and-figures-spanning-two-columns-in-journal-mode>
When creating tables and figures in journal mode, care must be taken not to make figures and tables wider than the columns, otherwise \$\\LaTeX\$ sometimes makes them disappear.

As demonstrated in #ref(<fig-twocolumn>, supplement: [Figure]), you can make figures tables span the two columns by setting the `apa-twocolumn` chunk option to `true`.

#figure(
  [
    #box(image("index_files/figure-typst/fig-twocolumn-1.svg"))
  ],
  caption: figure.caption(
    position: bottom,
    [
      A Figure Spanning Two Columns When in Journal Mode
    ],
  ),
  kind: "quarto-float-fig",
  supplement: "Figure",
)
<fig-twocolumn>


== Math and Equations
<math-and-equations>
Inline math uses \$\\LaTeX\$ syntax with single dollar signs. For example, the reliability coefficient of my measure is $r_(X X) = .95$.

If you want to display and refer to a specific formula, enclose the formula in two dollar signs. After the second pair of dollar signs, place the label in curly braces. The label should have an `#eq-` prefix. To refer to the formula, use the same label but with the `@` symbol. For example, #ref(<eq-euler>, supplement: [Equation]) is Euler's Identity, which is much admired for its elegance.

== Citations
<citations>
See #link("https://quarto.org/docs/authoring/footnotes-and-citations.html")[here] for instructions on setting up citations and references.

A parenthetical citation requires square brackets @CameronTrivedi2013. This reference was in my bibliography file. An in-text citation is done like so:

#cite(<CameronTrivedi2013>, form: "prose") make some important points …

See #link("https://wjschne.github.io/apaquarto/writing.html#references")[here] for explanations, examples, and citation features exclusive to apaquarto. For example, apaquarto can automatically handle possessive citations:

#cite(<schneider2012cattell>, form: "prose", supplement: [s]) position was …

== Masking Author Identity for Peer Review
<masking-author-identity-for-peer-review>
Setting `mask` to `true` will remove author names, affiliations, and correspondence from the title page. Any references listed in the `masked-citations` field will be masked as well. See #link("https://wjschne.github.io/apaquarto/writing.html#masked-citations-for-anonymous-peer-review")[here] for more information.

#math.equation(block: true, numbering: "(1)", [ $ e^(i pi) + 1 = 0 $ ])<eq-euler>

== Block Quotes
<block-quotes>
Sometimes you want to give a longer quote that needs to go in its own paragraph. Block quotes are on their own line starting with the \> character. For example, #cite(<austenMansfieldPark1990>, form: "prose", supplement: [s]) #emph[Mansfield Park] has some memorable insights about the mind:

#quote(block: true)[
  If any one faculty of our nature may be called more wonderful than the rest, I do think it is memory. There seems something more speakingly incomprehensible in the powers, the failures, the inequalities of memory, than in any other of our intelligences. The memory is sometimes so retentive, so serviceable, so obedient; at others, so bewildered and so weak; and at others again, so tyrannic, so beyond control! We are, to be sure, a miracle every way; but our powers of recollecting and of forgetting do seem peculiarly past finding out. (p.~163)
]

If your quote has multiple paragraphs, like this passage from #cite(<brownHowKilledPluto2012>, form: "prose");, separate them with a lone `>` character between the lines:

#quote(block: true)[
  In the entire field of astronomy, there is no word other than #emph[planet] that has a precise, lawyerly definition, in which certain criteria are specifically enumerated. Why does #emph[planet] have such a definition but #emph[star];, #emph[galaxy];, and #emph[giant molecular cloud] do not? Because in astronomy, as in most sciences, scientists work by concepts rather than by definitions. The concept of a star is clear; a star is a collection of gas with fusion reactions in the interior giving off energy. A galaxy is a large, bound collection of stars. A giant molecular cloud is a giant cloud of molecules. The concept of a planet—in the eight-planet solar system—is equally simple to state. A planet is a one of a small number of bodies that dominate a planetary system. That is a concept, not a definition. How would you write that down in a precise definition?

  I wouldn't. Once you write down a definition with lawyerly precision, you get the lawyers involved in deciding whether or not your objects are planets. Astronomers work in concepts. We rarely call in the attorneys for adjudication. (p.~242)
]

== Hypotheses, Aims, and Objectives
<hypotheses-aims-and-objectives>
The last paragraph of the introduction usually states the specific hypotheses of the study, often in a way that links them to the research design.

= Method
<method>
General remarks on method. This paragraph is optional.

Not all papers require each of these sections. Edit them as needed. Consult the #link("https://apastyle.apa.org/jars")[Journal Article Reporting Standards] for what is needed for your type of article.

== Participants
<participants>
Who are they? How were they recruited? Report criteria for participant inclusion and exclusion. Perhaps some basic demographic stats are in order. A table is a great way to avoid repetition in statistical reporting.

== Measures
<measures>
This section can also be titled #strong[Materials] or #strong[Apparatus];.
Whatever tools, equipment, or measurement devices used in the study should be
described.

- Test 1
  - Test 1a
  - Test 1b

+ Scale 1
  + scale 1a
  + scale 1b

- Test 2
- Test 3
  - Test 3a
  - Test 3b
#sym.permille


=== Measure A
<measure-a>
Describe Measure A.

=== Measure B
<measure-b>
Describe Measure B.

==== Subscale B1
<subscale-b1>
A paragraph after a 4th-level header will appear on the same line as the header.

==== Subscale B2
<subscale-b2>
A paragraph after a 4th-level header will appear on the same line as the header.

===== Subscale B2a
<subscale-b2a>
A paragraph after a 5th-level header will appear on the same line as the header.

===== Subscale B2b
<subscale-b2b>
A paragraph after a 5th-level header will appear on the same line as the header.

== Procedure
<procedure>
What did participants do? How are the data going to be analyzed?

= Results
<results>
== Descriptive Statistics
<descriptive-statistics>
Describe the basic characteristics of the primary variables. My ideal is to describe the variables well enough that someone conducting a meta-analysis can include the study without needing to ask for additional information.

= Discussion
Describe results in non-statistical terms.

// #cite(<trampushModeratorEffectsWorking2014>)

== Limitations and Future Directions
<limitations-and-future-directions>
Every study has limitations. Based on this study, some additional steps might include…

== Conclusion
<conclusion>
Describe the main point of the paper.

= References
<references>
#block[ ] <refs>
= Appendix
<appendix>
= The Title for Appendix
<the-title-for-appendix>
If there are multiple appendices, label them with level 1 headings as Appendix A, Appendix B, and so forth.

Tables and figures in the first appendix automatically get the prefix "A", and the numbering starts again at 1. See #ref(<fig-appendfig>, supplement: [Figure]).

If there were a second appendix, tables and figures would get the prefix "B", and the numbering starts again at 1. Make as many appendices as needed.

#figure(
  [
    #box(image("sampleimage.png"))
  ],
  caption: figure.caption(
    position: bottom,
    [
      Appendix Figure
    ],
  ),
  kind: "quarto-float-fig",
  supplement: "Figure",
)
<fig-appendfig>






#bibliography("bibliography.bib")
