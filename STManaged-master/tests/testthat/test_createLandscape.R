context("Create landscape")
library(STManaged)

test_that("create_virtual_landscape returns a list of 6 elements", {

  initLand <- create_virtual_landscape(cellSize = 4)

  expect_equal(names(initLand), c("land", "env1", "nCol", "nRow", "position", "neighbor"))
})

test_that("create_virtual_landscape returns an integer vector with four forest states", {

  initLand <- create_virtual_landscape(cellSize = 4)
  land <- initLand[['land']]

  expect_equal(sort(unique(land)), c(1, 2, 3, 4))
  expect_match(class(land), "integer")
})

test_that("create_virtual_landscape returns good dimensions", {

  initLand <- create_virtual_landscape(cellSize = 4)
  nCol <- initLand[['nCol']]
  nRow <- initLand[['nRow']]

  expect_true(nCol > nRow)
})

test_that("create_virtual_landscape position and neighbor are correct", {

  initLand <- create_virtual_landscape(cellSize = 4)
  position <- initLand[['position']]
  neighbor <- initLand[['neighbor']]

  expect_identical(length(position), length(neighbor))
  expect_equal(position[1], initLand[['nCol']] + 2)
  expect_equal(position[1], neighbor[[1]][5])
})

test_that("create_virtual_landscape position and neighbor are correct", {

  initLand <- create_virtual_landscape(cellSize = 4)
  position <- initLand[['position']]
  neighbor <- initLand[['neighbor']]

  expect_identical(length(position), length(neighbor))
  expect_equal(position[1], initLand[['nCol']] + 2)
  expect_equal(position[1], neighbor[[1]][5])
})
