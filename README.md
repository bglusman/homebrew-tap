# Homebrew Tap for Calciforge/Wardwright

This tap publishes Wardwright and Calciforge release-candidate and release formulae.

```bash
brew tap bglusman/tap
brew install calciforge
brew install wardwright
```

Calciforge's Homebrew formula installs released binaries and a `brew services`
entry. It does not discover or wire agents by itself. Use the source-tree
installer from the main Calciforge repository when you want managed agent
configuration, certificate setup, or first-run bootstrap.

Wardwright is still in development and any versions are pre-release previews to play with and offer feedback on 
