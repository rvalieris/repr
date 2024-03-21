test_that('A basic tag works', {
	r <- repr_html(htmltools::div())
	expect_identical(r, sprintf(repr:::HTML_SKELETON, '', '<div></div>'))
})

test_that('A basic widget works', {
	r <- repr_html(str_view('xy', 'y'))
	expect_match(r, "x<span class='match'>y<\\/span>", fixed = TRUE, all = FALSE)
})

test_that('Dependencies work', {
	r <- repr_html(str_view('xy', 'y'))
	expect_match(r, '<script title="htmlwidgets" src="data:application/javascript', fixed = TRUE, all = FALSE)
})

test_that('The dependency manager works', {
	o <- options(repr.html.deduplicate = TRUE)
	on.exit(options(o))
	html_dependencies$clear()
	
	r <- render_tags(str_view('xy', 'y'))
	expect_true(length(r$dependencies) > 0)
	
	r <- render_tags(str_view('xy', 'y'))
	expect_true(length(r$dependencies) == 0)  #no deps here
})

test_that('Leaflet HTML and deps can be represented', {
	skip_if_not_installed('leaflet')

	leaf <- leaflet::addTiles(leaflet::leaflet())

	r <- repr_html(leaf)
	expect_match(r, '<script title="htmlwidgets" src="data:')
})
