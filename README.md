# Homebrew Tap for Calciforge

This tap publishes Calciforge release-candidate and release formulae.

```bash
brew tap bglusman/tap
brew install calciforge
```

Calciforge's Homebrew formula installs released binaries and a `brew services`
entry. It does not discover or wire agents by itself. Use the source-tree
installer from the main Calciforge repository when you want managed agent
configuration, certificate setup, or first-run bootstrap.

