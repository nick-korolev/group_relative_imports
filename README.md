# Zig Replace Absolute Imports

## Description

This Zig project is designed to replace absolute component imports with relative ones if the component is a direct descendant. For example, an import like `@app/components/SomeComponent` will be replaced with a relative import if the component is in a folder structure where it is a direct child.

## Example

Folder Structure:

```
-DashboardCard
  -DashboardCardTitle
    -index.tsx
  -index.tsx
```

Absolute Import in DashboardCard:

```typescript
import DashboardCardTitle from '@app/components/DashboardCard/DashboardCardTitle';
```

After running the script:

```typescript
import DashboardCardTitle from './DashboardCardTitle';
```

## Installation

To install Zig, follow the instructions on the [official website](https://ziglang.org/download/).

## Usage

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/zig-group-relative-imports.git
   cd zig-group-relative-imports
   ```

2. Build the project:
   ```sh
   zig build
   ```

3. Run the script:
   ```sh
   ./zig-out/bin/relative-imports <path_to_your_project>
   ```

### Step-by-Step Process:

1. **Scan Project Directory:** The script recursively scans the project directory to locate all files that might contain imports.
2. **Identify Absolute Imports:** It parses each file to find import statements matching the root import path defined in the configuration.
3. **Determine Relative Paths:** For each matching import, the script calculates the relative path based on the file's location.
4. **Replace Imports:** The absolute imports are then replaced with the computed relative paths.
