return {
  'brianhuster/live-preview.nvim',
  config = function()
    require('livepreview.config').set {
      port = 3000,
      browser = 'default',
      dynamic_root = true,
    }
  end,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
}
