const production = (process.env.NODE_ENV === "production");

module.exports = {
  devtool: !production ? 'inline-source-map' :  false,
  entry: ['./cli/main.ts'],
  target: "node",
  node: {
    __dirname: false,
    __filename: false,
    process: false,
  },
  output: {
    filename: './cli/bin/cli.js',
  },
  resolve: {
    extensions: ['.ts', '.js']
  },
  module: {
    loaders: [
      { 
        test: /\.ts$/, 
        loader: 'ts-loader'
      }
    ]
  }
};