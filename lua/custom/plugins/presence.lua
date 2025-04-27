return {
  'IogaMaster/neocord',
  event = 'VeryLazy',
  config = function()
    require('neocord').setup {
      logo = 'auto',
    }
  end,
}
