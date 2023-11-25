## Non-Secret Environment Variables

```yaml
- GitHub Username: m-c-frank
- Repository Name: apimesh
```

## OpenAI API Key in GitHub Actions

To access OpenAI in GitHub Actions, store the API key as a secret and reference it in your workflows:

### GitHub Actions Workflow Snippet

```yaml
env:
  OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
```

Add the above snippet to your GitHub Actions workflow file to use the OpenAI API key.
