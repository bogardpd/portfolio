const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    // Popper: ['popper.js', 'default'],
    // Tippy: ['tippy.js', 'default'],
  })
)
// const tippy = require('tippy.js').default;

module.exports = environment