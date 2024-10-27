local vim = vim
local api = vim.api

vim.opt_local.spell = false

vim.opt_local.tabstop = 4

local greek_tbl = {
  alpha = 'α',
  beta = 'β',
  gamma = 'γ',
  delta = 'δ',
  eps = 'ε',
  vareps = 'ϵ',
  zeta = 'ζ',
  eta = 'η',
  theta = 'θ',
  vartheta = 'ϑ',
  iota = 'ι',
  kappa = 'κ',
  lambda = 'λ',
  mu = 'μ',
  nu = 'ν',
  xi = 'ξ',
  pi = 'π',
  varpi = 'ϖ',
  rho = 'ρ',
  varrho = 'ϱ',
  sigma = 'σ',
  varsigma = 'ς',
  tau = 'τ',
  upsilon = 'υ',
  phi = 'φ',
  varphi = 'ϕ',
  chi = 'χ',
  psi = 'ψ',
  omega = 'ω',
  Gamma = 'Γ',
  Delta = 'Δ',
  Theta = 'Θ',
  Lambda = 'Λ',
  Xi = 'Ξ',
  Pi = 'Π',
  Sigma = 'Σ',
  Phi = 'Φ',
  Chi = 'Χ',
  Psi = 'Ψ',
  Omega = 'Ω',
}

local greek_map_tbl = {
  a = 'alpha',
  b = 'beta',
  c = 'chi',
  d = 'delta',
  e = 'eps',
  f = 'phi',
  g = 'gamma',
  h = 'eta',
  i = 'iota',
  k = 'kappa',
  l = 'lambda',
  m = 'mu',
  n = 'nu',
  p = 'pi',
  q = 'theta',
  r = 'rho',
  s = 'sigma',
  t = 'tau',
  u = 'upsilon',
  w = 'omega',
  x = 'xi',
  y = 'psi',
  z = 'zeta',
  D = 'Delta',
  F = 'Phi',
  G = 'Gamma',
  L = 'Lambda',
  P = 'Pi',
  Q = 'Theta',
  S = 'Sigma',
  W = 'Omega',
  X = 'Xi',
  Y = 'Psi',
}

for lhs, rhs in pairs(greek_map_tbl) do
  vim.keymap.set('i', '#' .. lhs, greek_tbl[rhs], { buffer = true })
end

api.nvim_buf_create_user_command(0, 'SubstituteGreek', function()
  for lhs, rhs in pairs(greek_tbl) do
    vim.cmd('silent! %s/' .. rhs .. '/' .. lhs)
  end
end, {})

api.nvim_buf_create_user_command(0, 'SubstituteRoman', function()
  for lhs, rhs in pairs(greek_tbl) do
    vim.cmd('silent! %s/' .. lhs .. '/' .. rhs)
  end
end, {})
