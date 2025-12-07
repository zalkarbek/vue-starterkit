import globals from 'globals';
import jseslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import eslintPluginVue from 'eslint-plugin-vue';
import { globalIgnores } from 'eslint/config';

export default tseslint.config([

  // -------------------------
  // Игнорируемые папки и файлы
  // -------------------------
  globalIgnores(['node_modules', 'dist']),
  {
    ignores: ['*.d.ts', '**/coverage', '**/dist'],
  },

  {
    files: ['**/*.{js,mjs,cjs,ts,mts,cts,vue}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      parserOptions: {
        parser: tseslint.parser,
      },
      globals: {
        ...globals.browser,
      },
    },

    extends: [
      jseslint.configs.recommended,             // базовые правила JS
      ...tseslint.configs.recommended,          // базовые правила TS
      ...eslintPluginVue.configs['flat/recommended'], // правила Vue в flat config
    ],

    rules: {
      // -------------------------
      // Код-стайл / стиль написания
      // -------------------------
      semi: ['error', 'always'],                          // Всегда ставим точку с запятой
      quotes: ['error', 'single', { avoidEscape: true }], // Одинарные кавычки для строк
      'comma-dangle': ['error', 'always-multiline'],      // Трейлинг-коммы в многострочных объектах/массивах
      'no-multiple-empty-lines': ['error', { max: 1 }],   // Не более одной пустой строки
      'max-len': ['warn', { code: 120 }],                 // Максимальная длина строки 120 символов
      'arrow-parens': ['error', 'always'],                // Скобки для стрелочных функций всегда
      'curly': ['error', 'all'],                          // Всегда использовать фигурные скобки
      'indent': ['error', 2],                             // 2 пробела для отступов

      // -------------------------
      // Безопасность JS/TS
      // -------------------------
      'no-eval': 'error',             // Запрет eval
      'no-implied-eval': 'error',     // Запрет косвенного eval
      'no-new-func': 'error',         // Запрет new Function()
      'no-unsafe-finally': 'error',   // Ошибки в finally
      'no-undef': 'error',            // Использование несуществующих переменных
      'no-unused-vars': ['error', {   // Неиспользуемые переменные
        args: 'after-used',
        ignoreRestSiblings: true,
      }],
      'eqeqeq': ['error', 'always'],  // Использовать === вместо ==
      'prefer-const': 'error',        // Предпочитать const, если переменная не изменяется
      'no-throw-literal': 'error',    // Запрет выбрасывать не-Error объекты

      // -------------------------
      // Vue: безопасность
      // -------------------------
      'vue/no-v-html': 'warn',                                // Предупреждение при использовании v-html (XSS)
      'vue/no-mutating-props': 'error',                       // Запрет мутировать props напрямую
      'vue/require-explicit-emits': 'error',                  // Все события компонента должны быть явно объявлены
      'vue/no-dupe-keys': 'error',                            // Дублирование ключей в data/props/computed
      'vue/no-duplicate-attributes': 'error',                 // Дублирование атрибутов в шаблоне
      'vue/no-side-effects-in-computed-properties': 'error',  // Запрет побочных эффектов в computed

      // -------------------------
      // Vue: стиль и читаемость
      // -------------------------
      'vue/max-attributes-per-line': ['warn', {   // Макс атрибутов на строку
        singleline: 3,
        multiline: 1,
      }],
      'vue/component-name-in-template-casing': [  // PascalCase для компонентов
        'error',
        'PascalCase',
      ],
      'vue/attribute-hyphenation': ['error', 'always'],         // Всегда kebab-case для атрибутов
      'vue/singleline-html-element-content-newline': ['warn', { // Перенос текста для элементов с атрибутами
        ignoreWhenNoAttributes: true,
      }],
      'vue/prefer-prop-type-boolean-first': 'warn', // Булевые props объявлять первыми
      'vue/no-v-text-v-html-on-component': 'error', // Запрет v-text/v-html на компонентах
      'vue/html-closing-bracket-newline': ['error', {
        'singleline': 'never',  // Для однострочных тегов — закрывающий на той же строке
        'multiline': 'always',  // Для многострочных тегов — всегда переносить на новую строку
      }],
      'vue/html-indent': ['error', 2, {
        'attribute': 1,                     // отступ для атрибутов в теге
        'baseIndent': 1,                    // вложенность контента
        'closeBracket': 0,                  // отступ закрывающего тега
        'alignAttributesVertically': true,  // выравнивание атрибутов вертикально
      }],
      'vue/script-indent': ['error', 2, {
        'baseIndent': 0,  // отступ для контента внутри <script>
        'switchCase': 1,  // отступ для case внутри switch
        'ignores': [],    // можно игнорировать строки, если нужно
      }],
    },
  },
]);
