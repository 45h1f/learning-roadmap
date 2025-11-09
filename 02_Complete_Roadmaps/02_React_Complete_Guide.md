# ⚛️ React Complete Guide - Master Modern React Development

> **Master React to build dynamic, interactive user interfaces with confidence.**

**Last Updated:** January 2025  
**Difficulty:** Beginner to Advanced  
**Time to Complete:** 3-4 weeks  
**React Version:** 18.3+ (with React 19 features)

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Why React?](#why-react)
3. [Getting Started](#getting-started)
4. [React Fundamentals](#react-fundamentals)
5. [Hooks Deep Dive](#hooks-deep-dive)
6. [Component Patterns](#component-patterns)
7. [State Management](#state-management)
8. [Performance Optimization](#performance-optimization)
9. [Advanced Patterns](#advanced-patterns)
10. [React 19 Features](#react-19-features)
11. [Testing React Apps](#testing-react-apps)
12. [Best Practices](#best-practices)
13. [Common Pitfalls](#common-pitfalls)
14. [Projects & Exercises](#projects--exercises)

---

## 🎯 Overview

### What is React?

**React = JavaScript Library for Building User Interfaces**

```jsx
// Traditional JavaScript (Vanilla)
const button = document.createElement('button');
button.textContent = 'Click me';
button.onclick = () => alert('Clicked!');
document.body.appendChild(button);

// React - Declarative & Component-Based
function App() {
  return (
    <button onClick={() => alert('Clicked!')}>
      Click me
    </button>
  );
}
```

### Key Features

- ✅ **Component-Based** - Build encapsulated components
- ✅ **Declarative** - Describe what UI should look like
- ✅ **Virtual DOM** - Efficient updates and rendering
- ✅ **One-Way Data Flow** - Predictable state management
- ✅ **Learn Once, Write Anywhere** - Web, mobile (React Native), desktop

### React Philosophy

```
UI = f(state)
```

Given the same state, React always renders the same UI.

---

## 💡 Why React?

### Industry Adoption

- 🏢 **Used by:** Facebook, Instagram, Netflix, Airbnb, Uber, Discord, WhatsApp
- 📈 **Most Popular:** #1 frontend framework (40%+ market share)
- 💼 **Jobs:** 80%+ of frontend jobs require React
- 🌐 **Ecosystem:** Largest component library and tool ecosystem

### Advantages

**1. Component Reusability**
```jsx
// Write once, use everywhere
<Button variant="primary" onClick={handleClick}>Submit</Button>
<Button variant="secondary" onClick={handleCancel}>Cancel</Button>
```

**2. Virtual DOM Performance**
```jsx
// React only updates what changed
setState({ count: count + 1 }); // Only re-renders affected components
```

**3. Strong Ecosystem**
- Next.js (Framework)
- React Router (Routing)
- Redux/Zustand (State management)
- React Query (Data fetching)
- Material-UI, Chakra UI (Component libraries)

---

## 🚀 Getting Started

### Quick Start (Create React App - Legacy)

```bash
# Create new React app (CRA - not recommended for new projects)
npx create-react-app my-app
cd my-app
npm start
```

### Modern Approach (Vite - Recommended)

```bash
# Create with Vite (faster, modern)
npm create vite@latest my-react-app -- --template react-ts
cd my-react-app
npm install
npm run dev
```

### Project Structure

```
my-react-app/
├── src/
│   ├── components/        # Reusable components
│   │   ├── Button.tsx
│   │   └── Card.tsx
│   ├── pages/            # Page components
│   │   ├── Home.tsx
│   │   └── About.tsx
│   ├── hooks/            # Custom hooks
│   │   └── useAuth.ts
│   ├── utils/            # Utility functions
│   ├── types/            # TypeScript types
│   ├── App.tsx           # Root component
│   └── main.tsx          # Entry point
├── public/               # Static assets
├── package.json
└── vite.config.ts
```

---

## 📚 React Fundamentals

### 1. JSX (JavaScript XML)

```jsx
// JSX looks like HTML but it's JavaScript
const element = <h1>Hello, React!</h1>;

// JSX expressions
const name = "John";
const greeting = <h1>Hello, {name}!</h1>;

// JSX attributes (camelCase)
const link = <a href="https://react.dev" className="link">React Docs</a>;

// JSX children
const container = (
  <div>
    <h1>Title</h1>
    <p>Paragraph</p>
  </div>
);

// JavaScript expressions in JSX
const result = <h1>{2 + 2}</h1>; // <h1>4</h1>

// Conditional rendering
const message = isLoggedIn ? <h1>Welcome back!</h1> : <h1>Please log in</h1>;

// Arrays and map
const items = ['Apple', 'Banana', 'Orange'];
const list = (
  <ul>
    {items.map((item, index) => (
      <li key={index}>{item}</li>
    ))}
  </ul>
);

// JSX prevents XSS attacks (auto-escapes)
const userInput = "<script>alert('XSS')</script>";
const safe = <div>{userInput}</div>; // Renders as text, not script

// Fragments (avoid unnecessary divs)
const fragment = (
  <>
    <h1>Title</h1>
    <p>Paragraph</p>
  </>
);
// Or with explicit Fragment
const explicitFragment = (
  <React.Fragment>
    <h1>Title</h1>
    <p>Paragraph</p>
  </React.Fragment>
);
```

### 2. Components

**Function Components (Modern, Recommended)**

```jsx
// Basic function component
function Welcome() {
  return <h1>Hello, World!</h1>;
}

// Arrow function component
const Welcome = () => {
  return <h1>Hello, World!</h1>;
};

// Implicit return (one-liner)
const Welcome = () => <h1>Hello, World!</h1>;

// Component with props
function Welcome({ name, age }) {
  return (
    <div>
      <h1>Hello, {name}!</h1>
      <p>Age: {age}</p>
    </div>
  );
}

// TypeScript props
interface WelcomeProps {
  name: string;
  age: number;
}

const Welcome: React.FC<WelcomeProps> = ({ name, age }) => {
  return (
    <div>
      <h1>Hello, {name}!</h1>
      <p>Age: {age}</p>
    </div>
  );
};

// Usage
<Welcome name="John" age={25} />
```

**Class Components (Legacy, Still Supported)**

```jsx
// Class component
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}!</h1>;
  }
}

// With state
class Counter extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
  }

  increment = () => {
    this.setState({ count: this.state.count + 1 });
  };

  render() {
    return (
      <div>
        <p>Count: {this.state.count}</p>
        <button onClick={this.increment}>Increment</button>
      </div>
    );
  }
}

// Lifecycle methods
class DataFetcher extends React.Component {
  componentDidMount() {
    // Called after component is mounted
    this.fetchData();
  }

  componentDidUpdate(prevProps, prevState) {
    // Called after component updates
    if (this.props.id !== prevProps.id) {
      this.fetchData();
    }
  }

  componentWillUnmount() {
    // Called before component is unmounted
    this.cleanup();
  }

  render() {
    return <div>{this.state.data}</div>;
  }
}
```

### 3. Props

```jsx
// Passing props
<Button text="Click me" variant="primary" onClick={handleClick} />

// Receiving props
function Button({ text, variant, onClick }) {
  return (
    <button className={`btn-${variant}`} onClick={onClick}>
      {text}
    </button>
  );
}

// Default props
function Button({ text = "Submit", variant = "primary", onClick }) {
  return (
    <button className={`btn-${variant}`} onClick={onClick}>
      {text}
    </button>
  );
}

// Props destructuring with rest
function Button({ text, variant, ...rest }) {
  return (
    <button className={`btn-${variant}`} {...rest}>
      {text}
    </button>
  );
}

// Children prop
function Card({ title, children }) {
  return (
    <div className="card">
      <h2>{title}</h2>
      <div className="card-body">{children}</div>
    </div>
  );
}

// Usage
<Card title="My Card">
  <p>This is the content</p>
  <button>Action</button>
</Card>

// Props validation (PropTypes)
import PropTypes from 'prop-types';

Button.propTypes = {
  text: PropTypes.string.isRequired,
  variant: PropTypes.oneOf(['primary', 'secondary']),
  onClick: PropTypes.func.isRequired
};

// TypeScript props (better!)
interface ButtonProps {
  text: string;
  variant?: 'primary' | 'secondary';
  onClick: () => void;
}

const Button: React.FC<ButtonProps> = ({ text, variant = 'primary', onClick }) => {
  return (
    <button className={`btn-${variant}`} onClick={onClick}>
      {text}
    </button>
  );
};
```

### 4. State

```jsx
import { useState } from 'react';

// Basic state
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

// Multiple state variables
function Form() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [age, setAge] = useState(0);

  return (
    <form>
      <input value={name} onChange={(e) => setName(e.target.value)} />
      <input value={email} onChange={(e) => setEmail(e.target.value)} />
      <input value={age} onChange={(e) => setAge(Number(e.target.value))} />
    </form>
  );
}

// Object state
function User() {
  const [user, setUser] = useState({
    name: '',
    email: '',
    age: 0
  });

  const updateName = (name) => {
    setUser({ ...user, name }); // Spread to avoid mutation
  };

  return <div>{user.name}</div>;
}

// Array state
function TodoList() {
  const [todos, setTodos] = useState([]);

  const addTodo = (text) => {
    setTodos([...todos, { id: Date.now(), text }]);
  };

  const removeTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>
          {todo.text}
          <button onClick={() => removeTodo(todo.id)}>Delete</button>
        </li>
      ))}
    </ul>
  );
}

// Functional updates (important for async updates)
function Counter() {
  const [count, setCount] = useState(0);

  const incrementTwice = () => {
    // ❌ Wrong - won't work as expected
    setCount(count + 1);
    setCount(count + 1);

    // ✅ Correct - uses functional update
    setCount(prev => prev + 1);
    setCount(prev => prev + 1);
  };

  return <button onClick={incrementTwice}>Increment Twice</button>;
}

// Lazy initialization (expensive computation)
function ExpensiveComponent() {
  // ❌ Runs on every render
  const [state, setState] = useState(expensiveComputation());

  // ✅ Only runs once
  const [state, setState] = useState(() => expensiveComputation());

  return <div>{state}</div>;
}
```

### 5. Events

```jsx
// Event handling
function Button() {
  const handleClick = () => {
    console.log('Button clicked!');
  };

  return <button onClick={handleClick}>Click me</button>;
}

// Inline event handler
<button onClick={() => console.log('Clicked!')}>Click me</button>

// Event with parameters
function List() {
  const handleClick = (id) => {
    console.log('Item clicked:', id);
  };

  return (
    <ul>
      {items.map(item => (
        <li key={item.id} onClick={() => handleClick(item.id)}>
          {item.name}
        </li>
      ))}
    </ul>
  );
}

// Event object
function Input() {
  const handleChange = (event) => {
    console.log('Value:', event.target.value);
  };

  return <input onChange={handleChange} />;
}

// Prevent default behavior
function Form() {
  const handleSubmit = (event) => {
    event.preventDefault();
    console.log('Form submitted');
  };

  return (
    <form onSubmit={handleSubmit}>
      <button type="submit">Submit</button>
    </form>
  );
}

// Stop propagation
function Parent() {
  const parentClick = () => console.log('Parent clicked');
  const childClick = (e) => {
    e.stopPropagation();
    console.log('Child clicked');
  };

  return (
    <div onClick={parentClick}>
      <button onClick={childClick}>Child</button>
    </div>
  );
}

// TypeScript event types
import { ChangeEvent, FormEvent, MouseEvent } from 'react';

function Form() {
  const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
  };

  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    console.log(e.target.value);
  };

  const handleClick = (e: MouseEvent<HTMLButtonElement>) => {
    console.log('Clicked at', e.clientX, e.clientY);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input onChange={handleChange} />
      <button onClick={handleClick}>Submit</button>
    </form>
  );
}
```

---

## 🪝 Hooks Deep Dive

### 1. useState

```jsx
import { useState } from 'react';

// Basic usage
const [state, setState] = useState(initialValue);

// With TypeScript
const [count, setCount] = useState<number>(0);
const [user, setUser] = useState<User | null>(null);

// Batch updates (React 18+)
function Counter() {
  const [count, setCount] = useState(0);

  const handleClick = () => {
    // React automatically batches these
    setCount(count + 1);
    setCount(count + 1);
    setCount(count + 1);
    // Only re-renders once!
  };
}

// Complex state patterns
function ShoppingCart() {
  const [cart, setCart] = useState({
    items: [],
    total: 0,
    discount: 0
  });

  const addItem = (item) => {
    setCart(prev => ({
      ...prev,
      items: [...prev.items, item],
      total: prev.total + item.price
    }));
  };

  const applyDiscount = (amount) => {
    setCart(prev => ({
      ...prev,
      discount: amount,
      total: prev.total - amount
    }));
  };
}
```

### 2. useEffect

```jsx
import { useEffect } from 'react';

// Basic effect (runs on every render)
useEffect(() => {
  console.log('Effect ran');
});

// Effect with dependencies (runs when deps change)
useEffect(() => {
  console.log('Count changed:', count);
}, [count]);

// Effect with empty deps (runs once on mount)
useEffect(() => {
  console.log('Component mounted');
}, []);

// Effect with cleanup
useEffect(() => {
  const timer = setInterval(() => {
    console.log('Tick');
  }, 1000);

  // Cleanup function
  return () => {
    clearInterval(timer);
  };
}, []);

// Data fetching
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let cancelled = false;

    const fetchUser = async () => {
      try {
        setLoading(true);
        const response = await fetch(`/api/users/${userId}`);
        const data = await response.json();
        
        if (!cancelled) {
          setUser(data);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err.message);
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    };

    fetchUser();

    // Cleanup to prevent state updates on unmounted component
    return () => {
      cancelled = true;
    };
  }, [userId]);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  return <div>{user.name}</div>;
}

// Event listeners
function WindowSize() {
  const [size, setSize] = useState({
    width: window.innerWidth,
    height: window.innerHeight
  });

  useEffect(() => {
    const handleResize = () => {
      setSize({
        width: window.innerWidth,
        height: window.innerHeight
      });
    };

    window.addEventListener('resize', handleResize);

    // Cleanup
    return () => {
      window.removeEventListener('resize', handleResize);
    };
  }, []);

  return <div>{size.width} x {size.height}</div>;
}

// Document title
function PageTitle({ title }) {
  useEffect(() => {
    document.title = title;
  }, [title]);
}
```

### 3. useContext

```jsx
import { createContext, useContext, useState } from 'react';

// Create context
const ThemeContext = createContext();

// Provider component
function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// Custom hook to use context
function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

// Using the context
function ThemedButton() {
  const { theme, toggleTheme } = useTheme();

  return (
    <button 
      onClick={toggleTheme}
      style={{ background: theme === 'light' ? 'white' : 'black' }}
    >
      Toggle Theme
    </button>
  );
}

// App structure
function App() {
  return (
    <ThemeProvider>
      <ThemedButton />
    </ThemeProvider>
  );
}

// Multiple contexts
const AuthContext = createContext();
const LanguageContext = createContext();

function App() {
  return (
    <AuthProvider>
      <LanguageProvider>
        <ThemeProvider>
          <Main />
        </ThemeProvider>
      </LanguageProvider>
    </AuthProvider>
  );
}

// TypeScript context
interface ThemeContextType {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);
```

### 4. useReducer

```jsx
import { useReducer } from 'react';

// Basic reducer
const initialState = { count: 0 };

function reducer(state, action) {
  switch (action.type) {
    case 'increment':
      return { count: state.count + 1 };
    case 'decrement':
      return { count: state.count - 1 };
    case 'reset':
      return initialState;
    default:
      throw new Error('Unknown action');
  }
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, initialState);

  return (
    <div>
      <p>Count: {state.count}</p>
      <button onClick={() => dispatch({ type: 'increment' })}>+</button>
      <button onClick={() => dispatch({ type: 'decrement' })}>-</button>
      <button onClick={() => dispatch({ type: 'reset' })}>Reset</button>
    </div>
  );
}

// Complex state management
const todoReducer = (state, action) => {
  switch (action.type) {
    case 'add':
      return [...state, { id: Date.now(), text: action.payload, completed: false }];
    case 'toggle':
      return state.map(todo =>
        todo.id === action.payload ? { ...todo, completed: !todo.completed } : todo
      );
    case 'delete':
      return state.filter(todo => todo.id !== action.payload);
    default:
      return state;
  }
};

function TodoList() {
  const [todos, dispatch] = useReducer(todoReducer, []);

  return (
    <div>
      <button onClick={() => dispatch({ type: 'add', payload: 'New todo' })}>
        Add Todo
      </button>
      {todos.map(todo => (
        <div key={todo.id}>
          <span onClick={() => dispatch({ type: 'toggle', payload: todo.id })}>
            {todo.text}
          </span>
          <button onClick={() => dispatch({ type: 'delete', payload: todo.id })}>
            Delete
          </button>
        </div>
      ))}
    </div>
  );
}

// TypeScript reducer
type State = { count: number };
type Action = 
  | { type: 'increment' }
  | { type: 'decrement' }
  | { type: 'reset' };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'increment':
      return { count: state.count + 1 };
    case 'decrement':
      return { count: state.count - 1 };
    case 'reset':
      return { count: 0 };
  }
}
```

### 5. useRef

```jsx
import { useRef, useEffect } from 'react';

// DOM reference
function TextInput() {
  const inputRef = useRef<HTMLInputElement>(null);

  const focusInput = () => {
    inputRef.current?.focus();
  };

  return (
    <div>
      <input ref={inputRef} />
      <button onClick={focusInput}>Focus Input</button>
    </div>
  );
}

// Storing mutable values (doesn't cause re-render)
function Timer() {
  const intervalRef = useRef<NodeJS.Timeout | null>(null);
  const [count, setCount] = useState(0);

  const startTimer = () => {
    intervalRef.current = setInterval(() => {
      setCount(prev => prev + 1);
    }, 1000);
  };

  const stopTimer = () => {
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
    }
  };

  useEffect(() => {
    return () => stopTimer(); // Cleanup
  }, []);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={startTimer}>Start</button>
      <button onClick={stopTimer}>Stop</button>
    </div>
  );
}

// Previous value tracking
function usePrevious(value) {
  const ref = useRef();

  useEffect(() => {
    ref.current = value;
  }, [value]);

  return ref.current;
}

function Counter() {
  const [count, setCount] = useState(0);
  const prevCount = usePrevious(count);

  return (
    <div>
      <p>Current: {count}</p>
      <p>Previous: {prevCount}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

// Measuring DOM elements
function MeasureDiv() {
  const divRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (divRef.current) {
      console.log('Width:', divRef.current.offsetWidth);
      console.log('Height:', divRef.current.offsetHeight);
    }
  }, []);

  return <div ref={divRef}>Measure me</div>;
}
```

### 6. useMemo & useCallback

```jsx
import { useMemo, useCallback, useState } from 'react';

// useMemo - Memoize expensive computations
function ExpensiveComponent({ data }) {
  // ❌ Recalculates on every render
  const processedData = expensiveOperation(data);

  // ✅ Only recalculates when data changes
  const processedData = useMemo(() => {
    return expensiveOperation(data);
  }, [data]);

  return <div>{processedData}</div>;
}

// Real-world useMemo example
function SearchResults({ query, items }) {
  const filteredItems = useMemo(() => {
    console.log('Filtering items...');
    return items.filter(item => 
      item.name.toLowerCase().includes(query.toLowerCase())
    );
  }, [query, items]);

  return (
    <ul>
      {filteredItems.map(item => (
        <li key={item.id}>{item.name}</li>
      ))}
    </ul>
  );
}

// useCallback - Memoize functions
function Parent() {
  const [count, setCount] = useState(0);
  const [other, setOther] = useState(0);

  // ❌ New function on every render (causes Child to re-render)
  const handleClick = () => {
    console.log('Clicked');
  };

  // ✅ Same function reference (Child won't re-render unnecessarily)
  const handleClick = useCallback(() => {
    console.log('Clicked');
  }, []);

  return (
    <div>
      <Child onClick={handleClick} />
      <button onClick={() => setOther(other + 1)}>Other State</button>
    </div>
  );
}

const Child = React.memo(({ onClick }) => {
  console.log('Child rendered');
  return <button onClick={onClick}>Click</button>;
});

// useCallback with dependencies
function SearchBox({ onSearch }) {
  const [query, setQuery] = useState('');

  const handleSearch = useCallback(() => {
    onSearch(query);
  }, [query, onSearch]);

  return (
    <div>
      <input value={query} onChange={(e) => setQuery(e.target.value)} />
      <button onClick={handleSearch}>Search</button>
    </div>
  );
}

// When to use useMemo vs useCallback
// useMemo: For expensive calculations
const expensiveValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);

// useCallback: For functions passed to child components
const handleClick = useCallback(() => doSomething(a, b), [a, b]);
```

### 7. Custom Hooks

```jsx
// Custom hook pattern
function useCustomHook(param) {
  const [state, setState] = useState(initialValue);

  useEffect(() => {
    // Side effects
  }, [param]);

  return [state, setState];
}

// useLocalStorage
function useLocalStorage(key, initialValue) {
  const [value, setValue] = useState(() => {
    const stored = localStorage.getItem(key);
    return stored ? JSON.parse(stored) : initialValue;
  });

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(value));
  }, [key, value]);

  return [value, setValue];
}

// Usage
function App() {
  const [name, setName] = useLocalStorage('name', 'John');
  
  return <input value={name} onChange={(e) => setName(e.target.value)} />;
}

// useFetch
function useFetch(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let cancelled = false;

    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetch(url);
        const json = await response.json();
        
        if (!cancelled) {
          setData(json);
          setError(null);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err.message);
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    };

    fetchData();

    return () => {
      cancelled = true;
    };
  }, [url]);

  return { data, loading, error };
}

// Usage
function UserProfile({ userId }) {
  const { data: user, loading, error } = useFetch(`/api/users/${userId}`);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  return <div>{user.name}</div>;
}

// useDebounce
function useDebounce(value, delay) {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(timer);
    };
  }, [value, delay]);

  return debouncedValue;
}

// Usage
function SearchBox() {
  const [query, setQuery] = useState('');
  const debouncedQuery = useDebounce(query, 500);

  useEffect(() => {
    if (debouncedQuery) {
      // API call with debounced query
      searchAPI(debouncedQuery);
    }
  }, [debouncedQuery]);

  return <input value={query} onChange={(e) => setQuery(e.target.value)} />;
}

// useToggle
function useToggle(initialValue = false) {
  const [value, setValue] = useState(initialValue);

  const toggle = useCallback(() => {
    setValue(prev => !prev);
  }, []);

  return [value, toggle];
}

// Usage
function Modal() {
  const [isOpen, toggleOpen] = useToggle(false);

  return (
    <div>
      <button onClick={toggleOpen}>Open Modal</button>
      {isOpen && <div>Modal Content</div>}
    </div>
  );
}

// useWindowSize
function useWindowSize() {
  const [size, setSize] = useState({
    width: window.innerWidth,
    height: window.innerHeight
  });

  useEffect(() => {
    const handleResize = () => {
      setSize({
        width: window.innerWidth,
        height: window.innerHeight
      });
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return size;
}

// useOnClickOutside
function useOnClickOutside(ref, handler) {
  useEffect(() => {
    const listener = (event) => {
      if (!ref.current || ref.current.contains(event.target)) {
        return;
      }
      handler(event);
    };

    document.addEventListener('mousedown', listener);
    document.addEventListener('touchstart', listener);

    return () => {
      document.removeEventListener('mousedown', listener);
      document.removeEventListener('touchstart', listener);
    };
  }, [ref, handler]);
}

// Usage
function Dropdown() {
  const [isOpen, setIsOpen] = useState(false);
  const ref = useRef();

  useOnClickOutside(ref, () => setIsOpen(false));

  return (
    <div ref={ref}>
      <button onClick={() => setIsOpen(!isOpen)}>Toggle</button>
      {isOpen && <div>Dropdown Content</div>}
    </div>
  );
}
```

---

## 🎨 Component Patterns

### 1. Container/Presentational Pattern

```jsx
// Presentational Component (UI only)
function UserCard({ user, onEdit, onDelete }) {
  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      <p>{user.email}</p>
      <button onClick={onEdit}>Edit</button>
      <button onClick={onDelete}>Delete</button>
    </div>
  );
}

// Container Component (Logic)
function UserCardContainer({ userId }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUser(userId).then(setUser).finally(() => setLoading(false));
  }, [userId]);

  const handleEdit = () => {
    // Edit logic
  };

  const handleDelete = () => {
    // Delete logic
  };

  if (loading) return <div>Loading...</div>;

  return (
    <UserCard 
      user={user} 
      onEdit={handleEdit} 
      onDelete={handleDelete} 
    />
  );
}
```

### 2. Compound Components

```jsx
// Tabs component using compound pattern
const TabsContext = createContext();

function Tabs({ children, defaultValue }) {
  const [activeTab, setActiveTab] = useState(defaultValue);

  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div className="tabs">{children}</div>
    </TabsContext.Provider>
  );
}

function TabList({ children }) {
  return <div className="tab-list">{children}</div>;
}

function Tab({ value, children }) {
  const { activeTab, setActiveTab } = useContext(TabsContext);
  const isActive = activeTab === value;

  return (
    <button
      className={isActive ? 'tab active' : 'tab'}
      onClick={() => setActiveTab(value)}
    >
      {children}
    </button>
  );
}

function TabPanel({ value, children }) {
  const { activeTab } = useContext(TabsContext);
  
  if (activeTab !== value) return null;
  
  return <div className="tab-panel">{children}</div>;
}

// Attach subcomponents
Tabs.List = TabList;
Tabs.Tab = Tab;
Tabs.Panel = TabPanel;

// Usage
function App() {
  return (
    <Tabs defaultValue="tab1">
      <Tabs.List>
        <Tabs.Tab value="tab1">Tab 1</Tabs.Tab>
        <Tabs.Tab value="tab2">Tab 2</Tabs.Tab>
      </Tabs.List>

      <Tabs.Panel value="tab1">
        <p>Content for Tab 1</p>
      </Tabs.Panel>

      <Tabs.Panel value="tab2">
        <p>Content for Tab 2</p>
      </Tabs.Panel>
    </Tabs>
  );
}
```

### 3. Render Props

```jsx
// Mouse position tracker with render props
function MouseTracker({ render }) {
  const [position, setPosition] = useState({ x: 0, y: 0 });

  useEffect(() => {
    const handleMouseMove = (e) => {
      setPosition({ x: e.clientX, y: e.clientY });
    };

    window.addEventListener('mousemove', handleMouseMove);
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, []);

  return render(position);
}

// Usage
function App() {
  return (
    <MouseTracker
      render={({ x, y }) => (
        <h1>
          Mouse position: {x}, {y}
        </h1>
      )}
    />
  );
}

// Or using children as a function
function MouseTracker({ children }) {
  const [position, setPosition] = useState({ x: 0, y: 0 });

  useEffect(() => {
    const handleMouseMove = (e) => {
      setPosition({ x: e.clientX, y: e.clientY });
    };

    window.addEventListener('mousemove', handleMouseMove);
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, []);

  return children(position);
}

// Usage
<MouseTracker>
  {({ x, y }) => <h1>Mouse: {x}, {y}</h1>}
</MouseTracker>
```

### 4. Higher-Order Components (HOC)

```jsx
// HOC to add logging
function withLogging(Component) {
  return function WithLogging(props) {
    useEffect(() => {
      console.log('Component mounted');
      return () => console.log('Component unmounted');
    }, []);

    return <Component {...props} />;
  };
}

// HOC to add authentication check
function withAuth(Component) {
  return function WithAuth(props) {
    const { isAuthenticated } = useAuth();

    if (!isAuthenticated) {
      return <Navigate to="/login" />;
    }

    return <Component {...props} />;
  };
}

// Usage
const ProtectedDashboard = withAuth(Dashboard);

// Multiple HOCs
const EnhancedComponent = withLogging(withAuth(Dashboard));
```

### 5. Controlled vs Uncontrolled Components

```jsx
// Controlled Component (React controls the state)
function ControlledInput() {
  const [value, setValue] = useState('');

  return (
    <input
      value={value}
      onChange={(e) => setValue(e.target.value)}
    />
  );
}

// Uncontrolled Component (DOM controls the state)
function UncontrolledInput() {
  const inputRef = useRef();

  const handleSubmit = () => {
    console.log(inputRef.current.value);
  };

  return (
    <div>
      <input ref={inputRef} defaultValue="Initial" />
      <button onClick={handleSubmit}>Submit</button>
    </div>
  );
}

// Controlled form
function ControlledForm() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    age: 0
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="name"
        value={formData.name}
        onChange={handleChange}
      />
      <input
        name="email"
        value={formData.email}
        onChange={handleChange}
      />
      <button type="submit">Submit</button>
    </form>
  );
}
```

---

## 🗄️ State Management

### 1. Local State (useState)

```jsx
// Component-level state
function Counter() {
  const [count, setCount] = useState(0);
  return <div>{count}</div>;
}
```

### 2. Context API

```jsx
// Global state with Context
const AppContext = createContext();

function AppProvider({ children }) {
  const [user, setUser] = useState(null);
  const [theme, setTheme] = useState('light');

  const value = {
    user,
    setUser,
    theme,
    setTheme
  };

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
}

function useApp() {
  return useContext(AppContext);
}
```

### 3. Zustand (Recommended for Global State)

```jsx
import create from 'zustand';

// Create store
const useStore = create((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
  decrement: () => set((state) => ({ count: state.count - 1 })),
  reset: () => set({ count: 0 })
}));

// Use in component
function Counter() {
  const { count, increment, decrement } = useStore();

  return (
    <div>
      <p>{count}</p>
      <button onClick={increment}>+</button>
      <button onClick={decrement}>-</button>
    </div>
  );
}

// Async actions
const useStore = create((set) => ({
  users: [],
  loading: false,
  fetchUsers: async () => {
    set({ loading: true });
    const users = await fetch('/api/users').then(r => r.json());
    set({ users, loading: false });
  }
}));
```

### 4. Redux Toolkit (For Complex Apps)

```jsx
import { configureStore, createSlice } from '@reduxjs/toolkit';

// Create slice
const counterSlice = createSlice({
  name: 'counter',
  initialState: { value: 0 },
  reducers: {
    increment: (state) => {
      state.value += 1;
    },
    decrement: (state) => {
      state.value -= 1;
    }
  }
});

// Create store
const store = configureStore({
  reducer: {
    counter: counterSlice.reducer
  }
});

// Use in component
import { useSelector, useDispatch } from 'react-redux';

function Counter() {
  const count = useSelector((state) => state.counter.value);
  const dispatch = useDispatch();

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => dispatch(counterSlice.actions.increment())}>+</button>
    </div>
  );
}
```

---

## ⚡ Performance Optimization

### 1. React.memo

```jsx
// Prevents re-render if props haven't changed
const ExpensiveComponent = React.memo(({ data }) => {
  console.log('Rendering ExpensiveComponent');
  return <div>{data}</div>;
});

// Custom comparison
const ExpensiveComponent = React.memo(
  ({ data }) => <div>{data}</div>,
  (prevProps, nextProps) => {
    // Return true if props are equal (skip re-render)
    return prevProps.data.id === nextProps.data.id;
  }
);
```

### 2. Code Splitting (Lazy Loading)

```jsx
import { lazy, Suspense } from 'react';

// Lazy load components
const Dashboard = lazy(() => import('./Dashboard'));
const Settings = lazy(() => import('./Settings'));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <Dashboard />
      <Settings />
    </Suspense>
  );
}

// Route-based code splitting
const routes = [
  {
    path: '/dashboard',
    component: lazy(() => import('./pages/Dashboard'))
  },
  {
    path: '/settings',
    component: lazy(() => import('./pages/Settings'))
  }
];
```

### 3. Virtualization (Large Lists)

```jsx
import { FixedSizeList } from 'react-window';

function VirtualList({ items }) {
  const Row = ({ index, style }) => (
    <div style={style}>
      {items[index].name}
    </div>
  );

  return (
    <FixedSizeList
      height={600}
      itemCount={items.length}
      itemSize={35}
      width="100%"
    >
      {Row}
    </FixedSizeList>
  );
}
```

### 4. Debouncing & Throttling

```jsx
// Debounce
function SearchBox() {
  const [query, setQuery] = useState('');
  const debouncedQuery = useDebounce(query, 500);

  useEffect(() => {
    if (debouncedQuery) {
      searchAPI(debouncedQuery);
    }
  }, [debouncedQuery]);

  return <input value={query} onChange={(e) => setQuery(e.target.value)} />;
}

// Throttle
function ScrollTracker() {
  const [scrollY, setScrollY] = useState(0);

  useEffect(() => {
    let ticking = false;

    const handleScroll = () => {
      if (!ticking) {
        window.requestAnimationFrame(() => {
          setScrollY(window.scrollY);
          ticking = false;
        });
        ticking = true;
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return <div>Scroll Y: {scrollY}</div>;
}
```

---

## 🚀 React 19 Features

### 1. use() Hook

```jsx
import { use } from 'react';

// Use promises directly in components
function User({ userPromise }) {
  const user = use(userPromise);
  return <div>{user.name}</div>;
}

// Use context without useContext
function ThemedButton() {
  const theme = use(ThemeContext);
  return <button style={{ background: theme.color }}>Click</button>;
}
```

### 2. Server Components (with Next.js)

```jsx
// Server Component (no 'use client')
async function UserList() {
  const users = await fetch('/api/users').then(r => r.json());
  
  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

// Client Component
'use client';

function InteractiveButton() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

### 3. Actions

```jsx
'use client';

import { useFormStatus, useFormState } from 'react-dom';

function Form() {
  async function submitAction(formData) {
    'use server';
    const name = formData.get('name');
    await saveToDatabase(name);
  }

  return (
    <form action={submitAction}>
      <input name="name" />
      <SubmitButton />
    </form>
  );
}

function SubmitButton() {
  const { pending } = useFormStatus();
  return <button disabled={pending}>Submit</button>;
}
```

---

## 🧪 Testing React Apps

### 1. React Testing Library

```jsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';

// Component to test
function Counter() {
  const [count, setCount] = useState(0);
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

// Test
describe('Counter', () => {
  test('renders initial count', () => {
    render(<Counter />);
    expect(screen.getByText('Count: 0')).toBeInTheDocument();
  });

  test('increments count on button click', () => {
    render(<Counter />);
    const button = screen.getByText('Increment');
    fireEvent.click(button);
    expect(screen.getByText('Count: 1')).toBeInTheDocument();
  });
});

// Async test
test('fetches and displays user', async () => {
  render(<UserProfile userId={1} />);
  
  expect(screen.getByText('Loading...')).toBeInTheDocument();
  
  await waitFor(() => {
    expect(screen.getByText('John Doe')).toBeInTheDocument();
  });
});

// Testing hooks
import { renderHook, act } from '@testing-library/react';

test('useCounter hook', () => {
  const { result } = renderHook(() => useCounter());
  
  expect(result.current.count).toBe(0);
  
  act(() => {
    result.current.increment();
  });
  
  expect(result.current.count).toBe(1);
});
```

---

## ✅ Best Practices

### 1. Component Structure

```jsx
// ✅ Good component structure
import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';

/**
 * User profile component
 * @param {Object} props
 * @param {number} props.userId - User ID to display
 */
function UserProfile({ userId }) {
  // 1. Hooks
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  // 2. Effects
  useEffect(() => {
    fetchUser(userId).then(setUser).finally(() => setLoading(false));
  }, [userId]);

  // 3. Event handlers
  const handleEdit = () => {
    // Edit logic
  };

  // 4. Render conditions
  if (loading) return <div>Loading...</div>;
  if (!user) return <div>User not found</div>;

  // 5. Main render
  return (
    <div className="user-profile">
      <h2>{user.name}</h2>
      <p>{user.email}</p>
      <button onClick={handleEdit}>Edit</button>
    </div>
  );
}

// 6. PropTypes (or TypeScript)
UserProfile.propTypes = {
  userId: PropTypes.number.isRequired
};

export default UserProfile;
```

### 2. Naming Conventions

```jsx
// ✅ Good naming
function UserProfile() {}          // PascalCase for components
const handleClick = () => {}       // camelCase for functions
const isLoading = true;            // camelCase for variables
const API_URL = 'https://...';     // UPPER_SNAKE_CASE for constants

// Event handlers
const handleClick = () => {}
const handleSubmit = () => {}
const handleInputChange = () => {}

// Boolean variables
const isLoading = true;
const hasError = false;
const canEdit = true;
```

### 3. Key Prop

```jsx
// ❌ Don't use index as key
{items.map((item, index) => <li key={index}>{item}</li>)}

// ✅ Use unique IDs
{items.map(item => <li key={item.id}>{item.name}</li>)}

// ✅ Generate stable keys if no ID
import { nanoid } from 'nanoid';
{items.map(item => <li key={item.uniqueKey || nanoid()}>{item.name}</li>)}
```

### 4. Component Composition

```jsx
// ❌ Don't create components inside components
function Parent() {
  function Child() {  // BAD: New component on every render
    return <div>Child</div>;
  }
  return <Child />;
}

// ✅ Define components outside
function Child() {
  return <div>Child</div>;
}

function Parent() {
  return <Child />;
}
```

### 5. Avoid Prop Drilling

```jsx
// ❌ Prop drilling
function App() {
  const [user, setUser] = useState(null);
  return <Parent user={user} setUser={setUser} />;
}

function Parent({ user, setUser }) {
  return <Child user={user} setUser={setUser} />;
}

function Child({ user, setUser }) {
  return <GrandChild user={user} setUser={setUser} />;
}

// ✅ Use Context
const UserContext = createContext();

function App() {
  const [user, setUser] = useState(null);
  return (
    <UserContext.Provider value={{ user, setUser }}>
      <Parent />
    </UserContext.Provider>
  );
}

function GrandChild() {
  const { user, setUser } = useContext(UserContext);
  return <div>{user.name}</div>;
}
```

---

## 🚫 Common Pitfalls

### 1. Infinite Loops

```jsx
// ❌ Infinite loop - missing dependency array
useEffect(() => {
  fetchData();
}); // Runs on EVERY render!

// ✅ Correct - runs once on mount
useEffect(() => {
  fetchData();
}, []);

// ❌ Infinite loop - updating dependency inside effect
useEffect(() => {
  setCount(count + 1);
}, [count]); // count changes → effect runs → count changes → ...

// ✅ Correct - use functional update
useEffect(() => {
  setCount(prev => prev + 1);
}, []); // Or remove count from dependencies
```

### 2. Stale Closures

```jsx
// ❌ Stale closure
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      console.log(count); // Always logs 0!
    }, 1000);

    return () => clearInterval(timer);
  }, []); // count is stale

  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}

// ✅ Fix 1: Add to dependencies
useEffect(() => {
  const timer = setInterval(() => {
    console.log(count);
  }, 1000);
  return () => clearInterval(timer);
}, [count]);

// ✅ Fix 2: Use ref
const countRef = useRef(count);
countRef.current = count;

useEffect(() => {
  const timer = setInterval(() => {
    console.log(countRef.current); // Always current value
  }, 1000);
  return () => clearInterval(timer);
}, []);
```

### 3. Mutating State

```jsx
// ❌ Mutating state directly
const [user, setUser] = useState({ name: 'John' });
user.name = 'Jane'; // BAD! Doesn't trigger re-render

// ✅ Create new object
setUser({ ...user, name: 'Jane' });

// ❌ Mutating array
const [items, setItems] = useState([1, 2, 3]);
items.push(4); // BAD!

// ✅ Create new array
setItems([...items, 4]);
```

### 4. Not Cleaning Up Effects

```jsx
// ❌ Memory leak
useEffect(() => {
  const timer = setInterval(() => {
    console.log('Tick');
  }, 1000);
  // No cleanup!
}, []);

// ✅ Cleanup
useEffect(() => {
  const timer = setInterval(() => {
    console.log('Tick');
  }, 1000);

  return () => {
    clearInterval(timer);
  };
}, []);
```

---

## 🎯 Projects & Exercises

### Project 1: Todo App

**Features:**
- Add/edit/delete todos
- Mark as complete
- Filter (all/active/completed)
- Local storage persistence

**Skills practiced:**
- useState, useEffect
- Event handling
- Conditional rendering
- Array operations

### Project 2: Weather App

**Features:**
- Search cities
- Display current weather
- 5-day forecast
- Geolocation

**Skills practiced:**
- API calls
- Async/await
- Error handling
- Custom hooks (useFetch)

### Project 3: Shopping Cart

**Features:**
- Product listing
- Add to cart
- Update quantity
- Calculate total
- Checkout flow

**Skills practiced:**
- Context API
- useReducer
- Complex state management
- Component composition

### Project 4: Chat Application

**Features:**
- Real-time messages
- Multiple rooms
- User presence
- Typing indicators

**Skills practiced:**
- WebSockets
- useRef
- Performance optimization
- React.memo

---

## 📚 Resources

### Official
- [React Documentation](https://react.dev) - New official docs
- [React GitHub](https://github.com/facebook/react)
- [React DevTools](https://react.dev/learn/react-developer-tools)

### Learning
- [React Tutorial](https://react.dev/learn) - Official tutorial
- [React Patterns](https://reactpatterns.com/) - Common patterns
- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)

### Tools
- [Vite](https://vitejs.dev/) - Fast build tool
- [Next.js](https://nextjs.org/) - React framework
- [React Router](https://reactrouter.com/) - Routing
- [React Query](https://tanstack.com/query/latest) - Data fetching
- [Zustand](https://github.com/pmndrs/zustand) - State management

### Testing
- [React Testing Library](https://testing-library.com/react)
- [Jest](https://jestjs.io/)
- [Vitest](https://vitest.dev/)

---

## ✅ React Mastery Checklist

- [ ] Understand JSX and components
- [ ] Master useState and useEffect
- [ ] Create custom hooks
- [ ] Use Context API effectively
- [ ] Implement useReducer for complex state
- [ ] Optimize with useMemo and useCallback
- [ ] Handle forms and validation
- [ ] Make API calls properly
- [ ] Implement routing (React Router)
- [ ] Test components with React Testing Library
- [ ] Build responsive UIs
- [ ] Deploy React apps
- [ ] Debug with React DevTools
- [ ] Understand React internals (Virtual DOM, Reconciliation)
- [ ] Build 5+ complete projects

---

**Remember: React is about thinking in components. Break your UI into small, reusable pieces! 🚀**

*Last Updated: January 2025*