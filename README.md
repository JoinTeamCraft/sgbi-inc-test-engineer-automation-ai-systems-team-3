# Robot Framework Python Automation Template

This is a clean template for a Robot Framework project with Python extensions.

## Structure

- **tests/**: Directory for test suites (organized by module).
- **resources/**: Directory for Robot keywords and locators.
- **python_lib/**: Directory for custom Python libraries.
- **config/**: Directory for configuration files.
- **results/**: Directory for test results.

## Usage

1. **Install Dependencies**:

   ```bash
   pip install robotframework robotframework-seleniumlibrary
   ```

2. **Implement Logic**:
   - Add locators to `resources/locators.robot`.
   - Add keywords to `resources/keywords.robot`.
   - Implement Python logic in `python_lib/`.

3. **Run Tests**:
   ```bash
   robot --outputdir results tests/
   ```
