#' Representations of functions
#' 
#' @aliases repr_html.function repr_latex.function repr_markdown.function
#' @name repr_*.function
#' @include utils.r
NULL

repr_function_generic <- function(f, fmt, escape, high.wrap, norm.wrap, highlight) {
	code <- deparse(f)
	if (highlight) {
		if (!requireNamespace('highr'))
			stop(sprintf('Tried to create a %s representation of a function with highlighting, but the `highlight` package is not installed!', fmt))
		code <- highr::hilight(code, fmt)
		wrap <- high.wrap
	} else {
		code <- escape(code)
		wrap <- norm.wrap
	}
	sprintf(wrap, paste(code, collapse = '\n'))
}

#' @export @name repr_*.function
repr_html.function <- function(obj, highlight = getOption('repr.function.highlight'), ...) {
	wrap <- '<pre class=language-r><code>%s</code></pre>'
	repr_function_generic(obj, 'html', html.escape, wrap, wrap, highlight, ...)
}

#' @export @name repr_*.function
repr_latex.function <- function(obj, highlight = getOption('repr.function.highlight'), ...) {
	minted.wrap <- '\\begin{minted}{r}\n%s\n\\end{minted}'
	repr_function_generic(obj, 'latex', latex.escape, '%s', minted.wrap, highlight, ...)
}

#' @export @name repr_*.function
repr_markdown.function <- function(obj, fenced = TRUE, ...) {
	code <- deparse(obj)
	if (fenced) {
		code <- c('```r', code, '```')
	} else {
		code <- paste0('\t', code)
	}
	paste(code, collapse = '\n')
}