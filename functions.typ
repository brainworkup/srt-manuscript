// Functions in Typst are defined using the `#let` keyword. Here's the basic syntax:


#let function_name(parameter1, parameter2) = {
  // Function body
  // Code that does something
  // Last expression is the return value
}


// For simple functions, you can use square brackets for the body:


#let simple_function(x) = [
  Some text with #x
]


// For functions with default parameters:


#let my_function(param1, param2: "default value", optional_param: none) = {
  // Function body
}


// Examples from your index.typ file:


// Simple function with one parameter
#let blockquote(body) = [
  #set text(size: 0.92em)
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

// Function with multiple parameters and defaults
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), 
             icon: none, icon_color: black) = {
  // Function body
}


// You can call functions using the hash symbol:


#my_function("hello", optional_param: true)
