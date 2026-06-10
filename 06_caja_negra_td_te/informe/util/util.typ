// Utilidades
#let AbbreviateByCaps(w) = {
  let chars = w.clusters()
  let caps = chars.filter(c => c == upper(c) and c != lower(c))
  caps.join("")
}
/// Abrevia un nombre completo mostrando el primer apellido y el primer nombre.
/// 
/// El nombre debe tener al menos tres palabras separadas por espacios.
///
/// - name (string): El nombre completo que se desea abreviar.
/// -> content
#let AbbreviateFullName(name) = {
  let parts = name.split(" ")
  parts.at(0)
  ", "
  parts.at(2)
}

// Funciones de componentes
#let fontBuild(content, weight, size, alignTo, color) = [
  #set text(size: size, weight: weight, fill: color)
  #if alignTo != none [
    #align(alignTo)[#content]
  ] else [
    #content
  ]
]
