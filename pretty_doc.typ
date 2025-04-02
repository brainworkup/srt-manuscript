[
    "#",
    "import",
    " ",
    "\"@preview/touying:0.6.1\"",
    Hardline,
    Hardline,
    "=",
    " ",
    "Introduction",
    Hardline,
    Hardline,
    "This is my introductory paragraph.",
    Hardline,
    "The title will be placed above it automatically.",
    Hardline,
    "*",
    "Do not start with an introductory heading",
    "*",
    " ",
    "(e.g.,",
    " ",
    "\"",
    "Introduction",
    "\"",
    ").",
    Hardline,
    "The title acts as your Level 1 heading for the introduction.",
    Hardline,
    Hardline,
    "Details about writing headings with markdown in APA style are ",
    "https://wjschne.github.io/apaquarto/writing.html#headings-in-apa-style[here]",
    ".",
    Hardline,
    Hardline,
    "==",
    " ",
    "Displaying Figures",
    Hardline,
    Hardline,
    "A reference label for a figure must have the prefix",
    " ",
    "`",
    "fig-",
    "`",
    ", and in a code chunk, the caption must be set with",
    " ",
    "`",
    "fig-cap",
    "`",
    ".",
    Hardline,
    "Captions are in",
    " ",
    "[",
    "title case",
    "]",
    "(",
    "https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case",
    ").",
    Hardline,
    Hardline,
    "New mode",
    " ",
    "|Syntax",
    " ",
    "|Example",
    Hardline,
    "---",
    "---",
    "---",
    Hardline,
    Nest(
        2,
        [
            "-",
            " ",
            "Code Prefix the code with",
            " ",
            "\\#",
            " ",
            "Number",
            ":",
            " ",
            "#",
            "(",
            Group(
                [
                    "1",
                    " ",
                    "+",
                    " ",
                    "2",
                ],
            ),
            ")",
        ],
    ),
    Hardline,
    Nest(
        2,
        [
            "-",
            " ",
            "Math Surround equation with",
            " ",
            "$",
            Nest(
                2,
                [
                    ".",
                    ".",
                ],
            ),
            "$",
            " ",
            "$",
            Nest(
                2,
                [
                    "-",
                    "x",
                ],
            ),
            "$",
            " ",
            "is the opposite of",
            " ",
            "$",
            Nest(
                2,
                "x",
            ),
            "$",
        ],
    ),
    Hardline,
    Nest(
        2,
        [
            "-",
            " ",
            "Markup Surround markup with",
            " ",
            "[",
            "..",
            "]",
            " ",
            "let name",
            " ",
            "=",
            " ",
            "[",
            "*",
            "Typst!",
            "*",
            "]",
        ],
    ),
    Hardline,
    Hardline,
    "===",
    " ",
    "Third level",
    Hardline,
    Hardline,
    "HOw does this look?",
    Hardline,
    Hardline,
    "Does this work on type? or not",
    Hardline,
]
#import "@preview/touying:0.6.1"

= Introduction

This is my introductory paragraph.
The title will be placed above it automatically.
*Do not start with an introductory heading* (e.g., "Introduction").
The title acts as your Level 1 heading for the introduction.

Details about writing headings with markdown in APA style are https://wjschne.github.io/apaquarto/writing.html#headings-in-apa-style[here].

== Displaying Figures

A reference label for a figure must have the prefix `fig-`, and in a code chunk, the caption must be set with `fig-cap`.
Captions are in [title case](https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case).

New mode |Syntax |Example
---------
- Code Prefix the code with \# Number: #(1 + 2)
- Math Surround equation with $..$ $-x$ is the opposite of $x$
- Markup Surround markup with [..] let name = [*Typst!*]

=== Third level

HOw does this look?

Does this work on type? or not
