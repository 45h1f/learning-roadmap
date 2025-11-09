# 🧪 Testing Complete Guide - Modern Testing Practices

> **Master testing from unit tests to E2E with Jest, Vitest, React Testing Library, Playwright, and Cypress**

---

## 📋 Table of Contents

1. [Introduction to Testing](#introduction-to-testing)
2. [Testing Fundamentals](#testing-fundamentals)
3. [Unit Testing with Jest/Vitest](#unit-testing-with-jestvitest)
4. [React Testing Library](#react-testing-library)
5. [Integration Testing](#integration-testing)
6. [E2E Testing with Playwright](#e2e-testing-with-playwright)
7. [E2E Testing with Cypress](#e2e-testing-with-cypress)
8. [API Testing](#api-testing)
9. [Mocking & Stubbing](#mocking--stubbing)
10. [Test-Driven Development (TDD)](#test-driven-development-tdd)
11. [Testing Best Practices](#testing-best-practices)
12. [Code Coverage](#code-coverage)
13. [CI/CD Integration](#cicd-integration)
14. [Performance Testing](#performance-testing)
15. [Visual Regression Testing](#visual-regression-testing)

---

## Introduction to Testing

### Why Test?

Testing provides:
- **Confidence** - Code works as expected
- **Documentation** - Tests show how code should work
- **Regression Prevention** - Catch bugs before production
- **Refactoring Safety** - Change code without fear
- **Better Design** - Testable code is better code

### Testing Pyramid

```
       /\
      /E2E\        <- Few, slow, expensive
     /------\
    / Integ \      <- Some, medium speed
   /----------\
  /   Unit     \   <- Many, fast, cheap
 /--------------\
```

- **70% Unit Tests** - Test individual functions/components
- **20% Integration Tests** - Test components working together
- **10% E2E Tests** - Test full user workflows

### Types of Testing

```typescript
// Unit Test - Single function
test('adds two numbers', () => {
  expect(add(2, 3)).toBe(5);
});

// Integration Test - Multiple components
test('form submission updates database', async () => {
  render(<ContactForm />);
  // Fill form, submit, check database
});

// E2E Test - Full user flow
test('user can complete checkout', async () => {
  await page.goto('/');
  await page.click('text=Shop');
  await page.click('text=Add to Cart');
  await page.click('text=Checkout');
  // Complete checkout flow
});
```

---

## Testing Fundamentals

### Test Anatomy (AAA Pattern)

```typescript
test('should calculate total price correctly', () => {
  // Arrange - Setup test data
  const items = [
    { name: 'Book', price: 10, quantity: 2 },
    { name: 'Pen', price: 5, quantity: 3 }
  ];

  // Act - Execute the code
  const total = calculateTotal(items);

  // Assert - Verify the result
  expect(total).toBe(35);
});
```

### Good Test Characteristics (F.I.R.S.T)

- **Fast** - Tests should run quickly
- **Independent** - Tests shouldn't depend on each other
- **Repeatable** - Same results every time
- **Self-Validating** - Pass or fail, no manual checking
- **Timely** - Written before or with the code

### Test Naming Convention

```typescript
// ✅ Good: Descriptive names
test('should return empty array when no users exist', () => {});
test('should throw error when email is invalid', () => {});
test('should disable submit button when form is invalid', () => {});

// ❌ Bad: Vague names
test('test user function', () => {});
test('it works', () => {});
test('test 1', () => {});
```

---

## Unit Testing with Jest/Vitest

### Setup

**Jest (Create React App, Next.js):**
```bash
bun add -d jest @types/jest
bun add -d @testing-library/jest-dom
```

```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
  ],
};
```

**Vitest (Vite projects - FASTER):**
```bash
bun add -d vitest @vitest/ui
bun add -d @testing-library/react @testing-library/jest-dom
```

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './src/test/setup.ts',
  },
});
```

### Basic Assertions

```typescript
// Equality
expect(value).toBe(5);                    // Strict equality (===)
expect(value).toEqual({ name: 'John' });  // Deep equality
expect(value).not.toBe(3);

// Truthiness
expect(value).toBeTruthy();
expect(value).toBeFalsy();
expect(value).toBeNull();
expect(value).toBeUndefined();
expect(value).toBeDefined();

// Numbers
expect(value).toBeGreaterThan(10);
expect(value).toBeLessThan(100);
expect(value).toBeCloseTo(0.3);  // Floating point

// Strings
expect(str).toMatch(/pattern/);
expect(str).toContain('substring');

// Arrays
expect(array).toContain('item');
expect(array).toHaveLength(3);
expect(array).toEqual(expect.arrayContaining([1, 2]));

// Objects
expect(obj).toHaveProperty('name');
expect(obj).toHaveProperty('name', 'John');
expect(obj).toMatchObject({ age: 30 });

// Exceptions
expect(() => throwError()).toThrow();
expect(() => throwError()).toThrow('Error message');
expect(() => throwError()).toThrow(CustomError);

// Async
await expect(promise).resolves.toBe(5);
await expect(promise).rejects.toThrow();
```

### Testing Functions

```typescript
// utils.ts
export function add(a: number, b: number): number {
  return a + b;
}

export function multiply(a: number, b: number): number {
  return a * b;
}

export function divide(a: number, b: number): number {
  if (b === 0) throw new Error('Cannot divide by zero');
  return a / b;
}

// utils.test.ts
import { describe, it, expect } from 'vitest';
import { add, multiply, divide } from './utils';

describe('Math utilities', () => {
  describe('add', () => {
    it('should add two positive numbers', () => {
      expect(add(2, 3)).toBe(5);
    });

    it('should add negative numbers', () => {
      expect(add(-2, -3)).toBe(-5);
    });

    it('should handle zero', () => {
      expect(add(0, 5)).toBe(5);
    });
  });

  describe('multiply', () => {
    it('should multiply two numbers', () => {
      expect(multiply(3, 4)).toBe(12);
    });

    it('should return 0 when multiplying by 0', () => {
      expect(multiply(5, 0)).toBe(0);
    });
  });

  describe('divide', () => {
    it('should divide two numbers', () => {
      expect(divide(10, 2)).toBe(5);
    });

    it('should throw error when dividing by zero', () => {
      expect(() => divide(10, 0)).toThrow('Cannot divide by zero');
    });
  });
});
```

### Testing Async Code

```typescript
// api.ts
export async function fetchUser(id: string) {
  const response = await fetch(`/api/users/${id}`);
  if (!response.ok) throw new Error('User not found');
  return response.json();
}

// api.test.ts
import { describe, it, expect, vi } from 'vitest';
import { fetchUser } from './api';

describe('fetchUser', () => {
  it('should fetch user successfully', async () => {
    // Mock fetch
    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ id: '1', name: 'John' }),
    });

    const user = await fetchUser('1');
    
    expect(user).toEqual({ id: '1', name: 'John' });
    expect(fetch).toHaveBeenCalledWith('/api/users/1');
  });

  it('should throw error when user not found', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      ok: false,
    });

    await expect(fetchUser('999')).rejects.toThrow('User not found');
  });
});
```

### Setup and Teardown

```typescript
import { describe, it, beforeEach, afterEach, beforeAll, afterAll } from 'vitest';

describe('Database operations', () => {
  // Runs once before all tests
  beforeAll(async () => {
    await connectDatabase();
  });

  // Runs before each test
  beforeEach(async () => {
    await clearDatabase();
    await seedDatabase();
  });

  // Runs after each test
  afterEach(async () => {
    await clearDatabase();
  });

  // Runs once after all tests
  afterAll(async () => {
    await disconnectDatabase();
  });

  it('should create user', async () => {
    const user = await createUser({ name: 'John' });
    expect(user).toBeDefined();
  });

  it('should find user by id', async () => {
    const user = await createUser({ name: 'Jane' });
    const found = await findUser(user.id);
    expect(found.name).toBe('Jane');
  });
});
```

### Parameterized Tests

```typescript
import { describe, it, expect } from 'vitest';

describe('isPalindrome', () => {
  it.each([
    ['racecar', true],
    ['hello', false],
    ['A man a plan a canal Panama', true],
    ['', true],
    ['a', true],
  ])('should return %s for "%s"', (input, expected) => {
    expect(isPalindrome(input)).toBe(expected);
  });
});

// Or with objects
describe('calculateDiscount', () => {
  it.each([
    { price: 100, discount: 10, expected: 90 },
    { price: 50, discount: 20, expected: 40 },
    { price: 200, discount: 0, expected: 200 },
  ])('should calculate $expected when price is $price and discount is $discount%', 
    ({ price, discount, expected }) => {
      expect(calculateDiscount(price, discount)).toBe(expected);
    }
  );
});
```

---

## React Testing Library

### Setup

```typescript
// src/test/setup.ts
import '@testing-library/jest-dom';
import { cleanup } from '@testing-library/react';
import { afterEach } from 'vitest';

afterEach(() => {
  cleanup();
});
```

### Basic Component Testing

```typescript
// Button.tsx
interface ButtonProps {
  onClick: () => void;
  children: React.ReactNode;
  disabled?: boolean;
}

export function Button({ onClick, children, disabled }: ButtonProps) {
  return (
    <button onClick={onClick} disabled={disabled}>
      {children}
    </button>
  );
}

// Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { Button } from './Button';

describe('Button', () => {
  it('should render button with text', () => {
    render(<Button onClick={() => {}}>Click me</Button>);
    
    expect(screen.getByRole('button')).toHaveTextContent('Click me');
  });

  it('should call onClick when clicked', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByRole('button'));
    
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('should be disabled when disabled prop is true', () => {
    render(<Button onClick={() => {}} disabled>Click me</Button>);
    
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

### Querying Elements

```typescript
import { render, screen } from '@testing-library/react';

// By Role (PREFERRED)
screen.getByRole('button', { name: /submit/i });
screen.getByRole('heading', { level: 1 });
screen.getByRole('textbox', { name: /email/i });

// By Label Text
screen.getByLabelText('Email');
screen.getByLabelText(/password/i);

// By Placeholder
screen.getByPlaceholderText('Enter email...');

// By Text
screen.getByText('Hello World');
screen.getByText(/hello/i);

// By Test ID (last resort)
screen.getByTestId('custom-element');

// Query variants:
getBy...    // Throws error if not found
queryBy...  // Returns null if not found
findBy...   // Returns promise (for async)

// Multiple elements:
getAllBy...
queryAllBy...
findAllBy...
```

### User Interactions

```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

describe('Form', () => {
  it('should handle form submission', async () => {
    const user = userEvent.setup();
    const handleSubmit = vi.fn();
    
    render(<ContactForm onSubmit={handleSubmit} />);

    // Type in input
    await user.type(screen.getByLabelText('Name'), 'John Doe');
    await user.type(screen.getByLabelText('Email'), 'john@example.com');

    // Select from dropdown
    await user.selectOptions(screen.getByLabelText('Country'), 'US');

    // Check checkbox
    await user.click(screen.getByLabelText('Subscribe to newsletter'));

    // Submit form
    await user.click(screen.getByRole('button', { name: /submit/i }));

    expect(handleSubmit).toHaveBeenCalledWith({
      name: 'John Doe',
      email: 'john@example.com',
      country: 'US',
      subscribe: true,
    });
  });
});
```

### Testing Async Components

```typescript
// UserProfile.tsx
export function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUser(userId).then(data => {
      setUser(data);
      setLoading(false);
    });
  }, [userId]);

  if (loading) return <div>Loading...</div>;
  if (!user) return <div>User not found</div>;

  return <div>{user.name}</div>;
}

// UserProfile.test.tsx
import { render, screen, waitFor } from '@testing-library/react';
import { vi } from 'vitest';

describe('UserProfile', () => {
  it('should show loading state', () => {
    render(<UserProfile userId="1" />);
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });

  it('should display user name after loading', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ id: '1', name: 'John Doe' }),
    });

    render(<UserProfile userId="1" />);

    // Wait for loading to finish
    await waitFor(() => {
      expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
    });

    expect(screen.getByText('John Doe')).toBeInTheDocument();
  });

  it('should handle error state', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      ok: false,
    });

    render(<UserProfile userId="999" />);

    await screen.findByText('User not found');
  });
});
```

### Testing Hooks

```typescript
// useCounter.ts
export function useCounter(initialValue = 0) {
  const [count, setCount] = useState(initialValue);

  const increment = () => setCount(c => c + 1);
  const decrement = () => setCount(c => c - 1);
  const reset = () => setCount(initialValue);

  return { count, increment, decrement, reset };
}

// useCounter.test.ts
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('should initialize with default value', () => {
    const { result } = renderHook(() => useCounter());
    expect(result.current.count).toBe(0);
  });

  it('should initialize with custom value', () => {
    const { result } = renderHook(() => useCounter(10));
    expect(result.current.count).toBe(10);
  });

  it('should increment counter', () => {
    const { result } = renderHook(() => useCounter());
    
    act(() => {
      result.current.increment();
    });
    
    expect(result.current.count).toBe(1);
  });

  it('should decrement counter', () => {
    const { result } = renderHook(() => useCounter(5));
    
    act(() => {
      result.current.decrement();
    });
    
    expect(result.current.count).toBe(4);
  });

  it('should reset counter', () => {
    const { result } = renderHook(() => useCounter(10));
    
    act(() => {
      result.current.increment();
      result.current.increment();
      result.current.reset();
    });
    
    expect(result.current.count).toBe(10);
  });
});
```

### Testing Context

```typescript
// ThemeContext.tsx
const ThemeContext = createContext({ theme: 'light', toggleTheme: () => {} });

export function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');
  const toggleTheme = () => setTheme(t => t === 'light' ? 'dark' : 'light');

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// ThemeButton.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

function ThemeButton() {
  const { theme, toggleTheme } = useContext(ThemeContext);
  return <button onClick={toggleTheme}>{theme}</button>;
}

describe('ThemeButton', () => {
  it('should toggle theme', async () => {
    const user = userEvent.setup();
    
    render(
      <ThemeProvider>
        <ThemeButton />
      </ThemeProvider>
    );

    expect(screen.getByRole('button')).toHaveTextContent('light');

    await user.click(screen.getByRole('button'));

    expect(screen.getByRole('button')).toHaveTextContent('dark');
  });
});
```

---

## Integration Testing

### Testing Component Integration

```typescript
// TodoApp.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { TodoApp } from './TodoApp';

describe('TodoApp Integration', () => {
  it('should allow user to add and complete todos', async () => {
    const user = userEvent.setup();
    
    render(<TodoApp />);

    // Add first todo
    const input = screen.getByPlaceholderText('Add todo...');
    await user.type(input, 'Buy milk');
    await user.click(screen.getByRole('button', { name: /add/i }));

    expect(screen.getByText('Buy milk')).toBeInTheDocument();

    // Add second todo
    await user.type(input, 'Walk dog');
    await user.click(screen.getByRole('button', { name: /add/i }));

    expect(screen.getByText('Walk dog')).toBeInTheDocument();

    // Mark first todo as complete
    const todos = screen.getAllByRole('checkbox');
    await user.click(todos[0]);

    expect(todos[0]).toBeChecked();
    expect(todos[1]).not.toBeChecked();

    // Delete completed todo
    await user.click(screen.getByRole('button', { name: /delete/i }));

    expect(screen.queryByText('Buy milk')).not.toBeInTheDocument();
    expect(screen.getByText('Walk dog')).toBeInTheDocument();
  });
});
```

### Testing with API Calls (MSW)

```bash
bun add -d msw
```

```typescript
// mocks/handlers.ts
import { rest } from 'msw';

export const handlers = [
  rest.get('/api/users', (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json([
        { id: 1, name: 'John Doe' },
        { id: 2, name: 'Jane Smith' },
      ])
    );
  }),

  rest.post('/api/users', async (req, res, ctx) => {
    const body = await req.json();
    return res(
      ctx.status(201),
      ctx.json({ id: 3, ...body })
    );
  }),

  rest.get('/api/users/:id', (req, res, ctx) => {
    const { id } = req.params;
    return res(
      ctx.status(200),
      ctx.json({ id, name: `User ${id}` })
    );
  }),
];

// mocks/server.ts
import { setupServer } from 'msw/node';
import { handlers } from './handlers';

export const server = setupServer(...handlers);

// test/setup.ts
import { beforeAll, afterEach, afterAll } from 'vitest';
import { server } from './mocks/server';

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

// UserList.test.tsx
import { render, screen } from '@testing-library/react';
import { UserList } from './UserList';

describe('UserList', () => {
  it('should fetch and display users', async () => {
    render(<UserList />);

    expect(screen.getByText('Loading...')).toBeInTheDocument();

    expect(await screen.findByText('John Doe')).toBeInTheDocument();
    expect(await screen.findByText('Jane Smith')).toBeInTheDocument();
  });

  it('should handle error state', async () => {
    // Override handler for this test
    server.use(
      rest.get('/api/users', (req, res, ctx) => {
        return res(ctx.status(500));
      })
    );

    render(<UserList />);

    expect(await screen.findByText(/error/i)).toBeInTheDocument();
  });
});
```

---

## E2E Testing with Playwright

### Setup

```bash
bun add -d @playwright/test
bunx playwright install
```

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### Basic E2E Tests

```typescript
// e2e/homepage.spec.ts
import { test, expect } from '@playwright/test';

test('homepage has title', async ({ page }) => {
  await page.goto('/');
  
  await expect(page).toHaveTitle(/My App/);
});

test('navigation works', async ({ page }) => {
  await page.goto('/');
  
  await page.click('text=About');
  await expect(page).toHaveURL('/about');
  
  await page.click('text=Contact');
  await expect(page).toHaveURL('/contact');
});

test('search functionality', async ({ page }) => {
  await page.goto('/');
  
  await page.fill('input[placeholder="Search..."]', 'typescript');
  await page.press('input[placeholder="Search..."]', 'Enter');
  
  await expect(page).toHaveURL(/search\?q=typescript/);
  await expect(page.locator('h1')).toContainText('Results for typescript');
});
```

### Form Testing

```typescript
// e2e/contact.spec.ts
import { test, expect } from '@playwright/test';

test('contact form submission', async ({ page }) => {
  await page.goto('/contact');

  // Fill form
  await page.fill('input[name="name"]', 'John Doe');
  await page.fill('input[name="email"]', 'john@example.com');
  await page.fill('textarea[name="message"]', 'Hello, this is a test message');

  // Submit
  await page.click('button[type="submit"]');

  // Verify success message
  await expect(page.locator('text=Message sent successfully')).toBeVisible();

  // Verify form is cleared
  await expect(page.locator('input[name="name"]')).toHaveValue('');
});

test('form validation', async ({ page }) => {
  await page.goto('/contact');

  // Submit empty form
  await page.click('button[type="submit"]');

  // Check for validation errors
  await expect(page.locator('text=Name is required')).toBeVisible();
  await expect(page.locator('text=Email is required')).toBeVisible();

  // Fill invalid email
  await page.fill('input[name="email"]', 'invalid-email');
  await page.click('button[type="submit"]');

  await expect(page.locator('text=Invalid email address')).toBeVisible();
});
```

### Authentication Flow

```typescript
// e2e/auth.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('user can sign up', async ({ page }) => {
    await page.goto('/signup');

    await page.fill('input[name="email"]', 'newuser@example.com');
    await page.fill('input[name="password"]', 'SecurePass123!');
    await page.fill('input[name="confirmPassword"]', 'SecurePass123!');
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('text=Welcome')).toBeVisible();
  });

  test('user can login', async ({ page }) => {
    await page.goto('/login');

    await page.fill('input[name="email"]', 'user@example.com');
    await page.fill('input[name="password"]', 'password123');
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL('/dashboard');
  });

  test('user can logout', async ({ page }) => {
    // Login first
    await page.goto('/login');
    await page.fill('input[name="email"]', 'user@example.com');
    await page.fill('input[name="password"]', 'password123');
    await page.click('button[type="submit"]');

    // Logout
    await page.click('text=Logout');

    await expect(page).toHaveURL('/');
    await expect(page.locator('text=Login')).toBeVisible();
  });
});
```

### API Mocking in Playwright

```typescript
import { test, expect } from '@playwright/test';

test('mock API response', async ({ page }) => {
  // Intercept API calls
  await page.route('**/api/users', route => {
    route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify([
        { id: 1, name: 'Test User 1' },
        { id: 2, name: 'Test User 2' },
      ]),
    });
  });

  await page.goto('/users');

  await expect(page.locator('text=Test User 1')).toBeVisible();
  await expect(page.locator('text=Test User 2')).toBeVisible();
});

test('simulate API error', async ({ page }) => {
  await page.route('**/api/users', route => {
    route.fulfill({
      status: 500,
      body: 'Internal Server Error',
    });
  });

  await page.goto('/users');

  await expect(page.locator('text=Failed to load users')).toBeVisible();
});
```

### Page Object Model

```typescript
// e2e/pages/LoginPage.ts
import { Page, Locator } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.locator('input[name="email"]');
    this.passwordInput = page.locator('input[name="password"]');
    this.submitButton = page.locator('button[type="submit"]');
    this.errorMessage = page.locator('.error-message');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async getErrorMessage() {
    return await this.errorMessage.textContent();
  }
}

// e2e/login.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from './pages/LoginPage';

test('login with valid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);
  
  await loginPage.goto();
  await loginPage.login('user@example.com', 'password123');
  
  await expect(page).toHaveURL('/dashboard');
});

test('login with invalid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);
  
  await loginPage.goto();
  await loginPage.login('user@example.com', 'wrongpassword');
  
  const errorMessage = await loginPage.getErrorMessage();
  expect(errorMessage).toContain('Invalid credentials');
});
```

---

## E2E Testing with Cypress

### Setup

```bash
bun add -d cypress
bunx cypress open
```

```typescript
// cypress.config.ts
import { defineConfig } from 'cypress';

export default defineConfig({
  e2e: {
    baseUrl: 'http://localhost:3000',
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
  component: {
    devServer: {
      framework: 'react',
      bundler: 'vite',
    },
  },
});
```

### Basic Cypress Tests

```typescript
// cypress/e2e/homepage.cy.ts
describe('Homepage', () => {
  beforeEach(() => {
    cy.visit('/');
  });

  it('should display homepage title', () => {
    cy.get('h1').should('contain', 'Welcome');
  });

  it('should navigate to about page', () => {
    cy.get('a').contains('About').click();
    cy.url().should('include', '/about');
  });

  it('should search for items', () => {
    cy.get('input[placeholder="Search..."]').type('typescript{enter}');
    cy.url().should('include', 'search?q=typescript');
    cy.get('h1').should('contain', 'Results for typescript');
  });
});
```

### Form Testing in Cypress

```typescript
// cypress/e2e/contact.cy.ts
describe('Contact Form', () => {
  beforeEach(() => {
    cy.visit('/contact');
  });

  it('should submit form successfully', () => {
    cy.get('input[name="name"]').type('John Doe');
    cy.get('input[name="email"]').type('john@example.com');
    cy.get('textarea[name="message"]').type('Test message');
    
    cy.get('button[type="submit"]').click();
    
    cy.contains('Message sent successfully').should('be.visible');
  });

  it('should show validation errors', () => {
    cy.get('button[type="submit"]').click();
    
    cy.contains('Name is required').should('be.visible');
    cy.contains('Email is required').should('be.visible');
  });

  it('should validate email format', () => {
    cy.get('input[name="email"]').type('invalid-email');
    cy.get('button[type="submit"]').click();
    
    cy.contains('Invalid email address').should('be.visible');
  });
});
```

### Custom Commands

```typescript
// cypress/support/commands.ts
declare global {
  namespace Cypress {
    interface Chainable {
      login(email: string, password: string): Chainable<void>;
      logout(): Chainable<void>;
      getBySel(selector: string): Chainable<JQuery<HTMLElement>>;
    }
  }
}

Cypress.Commands.add('login', (email, password) => {
  cy.visit('/login');
  cy.get('input[name="email"]').type(email);
  cy.get('input[name="password"]').type(password);
  cy.get('button[type="submit"]').click();
});

Cypress.Commands.add('logout', () => {
  cy.get('button').contains('Logout').click();
});

Cypress.Commands.add('getBySel', (selector) => {
  return cy.get(`[data-testid="${selector}"]`);
});

// Usage in tests
describe('Authentication', () => {
  it('should login and logout', () => {
    cy.login('user@example.com', 'password123');
    cy.url().should('include', '/dashboard');
    
    cy.logout();
    cy.url().should('eq', Cypress.config().baseUrl + '/');
  });
});
```

### API Mocking in Cypress

```typescript
describe('User List', () => {
  beforeEach(() => {
    // Intercept API calls
    cy.intercept('GET', '/api/users', {
      statusCode: 200,
      body: [
        { id: 1, name: 'John Doe' },
        { id: 2, name: 'Jane Smith' },
      ],
    }).as('getUsers');

    cy.visit('/users');
  });

  it('should display users', () => {
    cy.wait('@getUsers');
    
    cy.contains('John Doe').should('be.visible');
    cy.contains('Jane Smith').should('be.visible');
  });

  it('should handle API error', () => {
    cy.intercept('GET', '/api/users', {
      statusCode: 500,
      body: { error: 'Internal Server Error' },
    });

    cy.visit('/users');
    cy.contains('Failed to load users').should('be.visible');
  });
});
```

---

## API Testing

### Testing REST APIs

```typescript
// api.test.ts
import { describe, it, expect, beforeAll, afterAll } from 'vitest';

describe('User API', () => {
  let userId: string;

  it('should create user', async () => {
    const response = await fetch('http://localhost:3000/api/users', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name: 'Test User',
        email: 'test@example.com',
      }),
    });

    expect(response.status).toBe(201);
    
    const data = await response.json();
    expect(data).toHaveProperty('id');
    expect(data.name).toBe('Test User');
    
    userId = data.id;
  });

  it('should get user by id', async () => {
    const response = await fetch(`http://localhost:3000/api/users/${userId}`);
    
    expect(response.status).toBe(200);
    
    const data = await response.json();
    expect(data.id).toBe(userId);
  });

  it('should update user', async () => {
    const response = await fetch(`http://localhost:3000/api/users/${userId}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'Updated Name' }),
    });

    expect(response.status).toBe(200);
    
    const data = await response.json();
    expect(data.name).toBe('Updated Name');
  });

  it('should delete user', async () => {
    const response = await fetch(`http://localhost:3000/api/users/${userId}`, {
      method: 'DELETE',
    });

    expect(response.status).toBe(204);
  });

  it('should return 404 for non-existent user', async () => {
    const response = await fetch('http://localhost:3000/api/users/999999');
    expect(response.status).toBe(404);
  });
});
```

### Testing with Supertest

```bash
bun add -d supertest @types/supertest
```

```typescript
import request from 'supertest';
import { app } from '../src/app';

describe('User API', () => {
  it('should create user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        name: 'Test User',
        email: 'test@example.com',
      })
      .expect(201);

    expect(response.body).toHaveProperty('id');
    expect(response.body.name).toBe('Test User');
  });

  it('should validate required fields', async () => {
    await request(app)
      .post('/api/users')
      .send({})
      .expect(400);
  });

  it('should get all users', async () => {
    const response = await request(app)
      .get('/api/users')
      .expect(200);

    expect(Array.isArray(response.body)).toBe(true);
  });
});
```

---

## Mocking & Stubbing

### Mocking Functions (Vitest)

```typescript
import { vi } from 'vitest';

// Mock function
const mockFn = vi.fn();

mockFn('hello');
mockFn('world');

expect(mockFn).toHaveBeenCalledTimes(2);
expect(mockFn).toHaveBeenCalledWith('hello');
expect(mockFn).toHaveBeenLastCalledWith('world');

// Mock implementation
const add = vi.fn((a, b) => a + b);
expect(add(2, 3)).toBe(5);

// Mock return value
const getName = vi.fn().mockReturnValue('John');
expect(getName()).toBe('John');

// Mock resolved value (async)
const fetchUser = vi.fn().mockResolvedValue({ id: 1, name: 'John' });
const user = await fetchUser();
expect(user.name).toBe('John');

// Mock rejected value
const failedFetch = vi.fn().mockRejectedValue(new Error('Failed'));
await expect(failedFetch()).rejects.toThrow('Failed');
```

### Mocking Modules

```typescript
// __mocks__/api.ts
export const fetchUser = vi.fn();
export const createUser = vi.fn();

// user.test.ts
import { vi } from 'vitest';
import { fetchUser } from './api';

vi.mock('./api');

describe('User component', () => {
  it('should display user name', async () => {
    fetchUser.mockResolvedValue({ id: 1, name: 'John' });
    
    render(<UserProfile userId="1" />);
    
    expect(await screen.findByText('John')).toBeInTheDocument();
  });
});
```

### Partial Mocking

```typescript
import { vi } from 'vitest';
import * as api from './api';

vi.spyOn(api, 'fetchUser').mockResolvedValue({ id: 1, name: 'John' });

// Other functions in api module work normally
```

### Mocking Dates and Timers

```typescript
import { vi } from 'vitest';

// Mock date
const mockDate = new Date('2025-01-15');
vi.setSystemTime(mockDate);

// Use fake timers
vi.useFakeTimers();

// Fast-forward time
vi.advanceTimersByTime(1000); // 1 second

// Run all timers
vi.runAllTimers();

// Restore real timers
vi.useRealTimers();
```

---

## Test-Driven Development (TDD)

### TDD Cycle (Red-Green-Refactor)

```typescript
// 1. RED - Write failing test
describe('Calculator', () => {
  it('should add two numbers', () => {
    const calculator = new Calculator();
    expect(calculator.add(2, 3)).toBe(5);
  });
});

// Test fails: Calculator class doesn't exist

// 2. GREEN - Write minimal code to pass
class Calculator {
  add(a: number, b: number): number {
    return a + b;
  }
}

// Test passes!

// 3. REFACTOR - Improve code
class Calculator {
  add(a: number, b: number): number {
    this.validateNumber(a);
    this.validateNumber(b);
    return a + b;
  }

  private validateNumber(n: number): void {
    if (typeof n !== 'number') {
      throw new Error('Input must be a number');
    }
  }
}

// Tests still pass!
```

### TDD Example: Shopping Cart

```typescript
// Step 1: Write test
describe('ShoppingCart', () => {
  it('should start empty', () => {
    const cart = new ShoppingCart();
    expect(cart.getItemCount()).toBe(0);
  });
});

// Step 2: Implement
class ShoppingCart {
  private items: any[] = [];

  getItemCount(): number {
    return this.items.length;
  }
}

// Step 3: Next test
it('should add item to cart', () => {
  const cart = new ShoppingCart();
  cart.addItem({ id: 1, name: 'Book', price: 10 });
  expect(cart.getItemCount()).toBe(1);
});

// Step 4: Implement
class ShoppingCart {
  private items: any[] = [];

  addItem(item: any): void {
    this.items.push(item);
  }

  getItemCount(): number {
    return this.items.length;
  }
}

// Continue with more tests...
it('should calculate total price', () => {
  const cart = new ShoppingCart();
  cart.addItem({ id: 1, name: 'Book', price: 10 });
  cart.addItem({ id: 2, name: 'Pen', price: 5 });
  expect(cart.getTotal()).toBe(15);
});
```

---

## Testing Best Practices

### 1. Test Behavior, Not Implementation

```typescript
// ❌ BAD: Testing implementation
it('should call setState with count + 1', () => {
  const setState = vi.fn();
  // Testing internal implementation
});

// ✅ GOOD: Testing behavior
it('should increment count when button clicked', async () => {
  render(<Counter />);
  await user.click(screen.getByRole('button', { name: /increment/i }));
  expect(screen.getByText('Count: 1')).toBeInTheDocument();
});
```

### 2. Write Maintainable Tests

```typescript
// ❌ BAD: Brittle, hard to maintain
it('test', () => {
  const div = document.querySelector('.container > div:nth-child(2) > span');
  expect(div.textContent).toBe('Hello');
});

// ✅ GOOD: Semantic, resilient
it('should display greeting message', () => {
  render(<Greeting name="John" />);
  expect(screen.getByRole('heading')).toHaveTextContent('Hello, John!');
});
```

### 3. Use Test Data Builders

```typescript
// testUtils.ts
export class UserBuilder {
  private user = {
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    role: 'user',
  };

  withName(name: string) {
    this.user.name = name;
    return this;
  }

  withRole(role: string) {
    this.user.role = role;
    return this;
  }

  build() {
    return this.user;
  }
}

// Usage in tests
const admin = new UserBuilder()
  .withName('Admin User')
  .withRole('admin')
  .build();
```

### 4. Avoid Test Interdependence

```typescript
// ❌ BAD: Tests depend on each other
let userId: string;

it('should create user', async () => {
  const user = await createUser({ name: 'John' });
  userId = user.id; // Shared state
});

it('should get user', async () => {
  const user = await getUser(userId); // Depends on previous test
  expect(user.name).toBe('John');
});

// ✅ GOOD: Independent tests
it('should create user', async () => {
  const user = await createUser({ name: 'John' });
  expect(user).toHaveProperty('id');
});

it('should get user', async () => {
  const created = await createUser({ name: 'Jane' });
  const fetched = await getUser(created.id);
  expect(fetched.name).toBe('Jane');
});
```

### 5. Test Edge Cases

```typescript
describe('divide', () => {
  it('should divide positive numbers', () => {
    expect(divide(10, 2)).toBe(5);
  });

  it('should handle negative numbers', () => {
    expect(divide(-10, 2)).toBe(-5);
  });

  it('should handle division by zero', () => {
    expect(() => divide(10, 0)).toThrow();
  });

  it('should handle very large numbers', () => {
    expect(divide(1e308, 2)).toBe(5e307);
  });

  it('should handle very small numbers', () => {
    expect(divide(1e-308, 2)).toBeCloseTo(5e-309);
  });
});
```

---

## Code Coverage

### Setup Coverage

```json
// package.json
{
  "scripts": {
    "test": "vitest",
    "test:coverage": "vitest --coverage"
  }
}
```

```bash
# Run with coverage
bun run test:coverage

# View coverage report
open coverage/index.html
```

### Coverage Metrics

- **Line Coverage** - % of lines executed
- **Branch Coverage** - % of if/else branches tested
- **Function Coverage** - % of functions called
- **Statement Coverage** - % of statements executed

### Coverage Goals

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      lines: 80,        // 80% line coverage required
      functions: 80,
      branches: 80,
      statements: 80,
    },
  },
});
```

### Don't Chase 100% Coverage

```typescript
// Some code doesn't need testing:

// ❌ Don't test
export const API_URL = 'https://api.example.com';

// ❌ Don't test
export type User = {
  id: string;
  name: string;
};

// ✅ DO test business logic
export function calculateDiscount(price: number, userType: string) {
  // Complex logic here - NEEDS tests
}
```

---

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Bun
        uses: oven-sh/setup-bun@v1
        
      - name: Install dependencies
        run: bun install
        
      - name: Run tests
        run: bun test
        
      - name: Run E2E tests
        run: bunx playwright test
        
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json
```

---

## Performance Testing

### Lighthouse CI

```bash
bun add -d @lhci/cli
```

```javascript
// lighthouserc.js
module.exports = {
  ci: {
    collect: {
      url: ['http://localhost:3000'],
      numberOfRuns: 3,
    },
    assert: {
      assertions: {
        'categories:performance': ['error', { minScore: 0.9 }],
        'categories:accessibility': ['error', { minScore: 0.9 }],
        'categories:best-practices': ['error', { minScore: 0.9 }],
        'categories:seo': ['error', { minScore: 0.9 }],
      },
    },
  },
};
```

---

## Visual Regression Testing

### Playwright Screenshots

```typescript
import { test, expect } from '@playwright/test';

test('visual regression test', async ({ page }) => {
  await page.goto('/');
  
  // Take screenshot and compare
  await expect(page).toHaveScreenshot('homepage.png');
});
```

### Percy (Visual Testing Service)

```bash
bun add -d @percy/playwright
```

```typescript
import { test } from '@playwright/test';
import percySnapshot from '@percy/playwright';

test('visual test with Percy', async ({ page }) => {
  await page.goto('/');
  await percySnapshot(page, 'Homepage');
});
```

---

## 🎯 Testing Checklist

- [ ] **Unit tests** for utility functions
- [ ] **Component tests** for UI components
- [ ] **Integration tests** for feature workflows
- [ ] **E2E tests** for critical user journeys
- [ ] **API tests** for backend endpoints
- [ ] **Error handling** tests
- [ ] **Edge cases** covered
- [ ] **Accessibility** tests
- [ ] **Performance** tests
- [ ] **Visual regression** tests
- [ ] **CI/CD** pipeline with tests
- [ ] **Code coverage** > 80%

---

## 📚 Resources

- **Testing Library**: https://testing-library.com/
- **Vitest**: https://vitest.dev/
- **Playwright**: https://playwright.dev/
- **Cypress**: https://www.cypress.io/
- **MSW**: https://mswjs.io/

**You're now ready to write production-quality tests!** 🚀