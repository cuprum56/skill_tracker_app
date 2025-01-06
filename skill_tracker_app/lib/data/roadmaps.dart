const Map<String, List<Map<String, dynamic>>> roadmaps = {
  'Программирование на phyton': pythonRoadmap,
};


const List<Map<String, dynamic>> pythonRoadmap = [
  {
    "title": "1. Вводная часть (неделя 1)",
    "topics": [
      {
        "title": "1.1 Ознакомление с Python: что это за язык, где и как он используется.",
        "links": [
          "https://www.python.org/about/",
          "https://realpython.com/python-introduction/"
        ]
      },
      {
        "title": "1.2 Установка среды разработки: Python, pip, IDE (напр., PyCharm, VS Code).",
        "links": [
          "https://www.python.org/downloads/",
          "https://code.visualstudio.com/docs/python/python-tutorial"
        ]
      },
      {
        "title": "1.3 Знакомство с текстовыми редакторами и командной строкой.",
        "links": [
          "https://realpython.com/python-command-line/",
          "https://www.geeksforgeeks.org/command-line-python/"
        ]
      }
    ]
  },
  {
    "title": "2. Базовые концепции Python (недели 2–4)",
    "topics": [
      {
        "title": "2.1 Основы синтаксиса Python: переменные, типы данных, вывод и ввод данных.",
        "links": [
          "https://www.w3schools.com/python/python_syntax.asp",
          "https://realpython.com/python-data-types/"
        ]
      },
      {
        "title": "2.2 Основные операторы (арифметические, логические, сравнения).",
        "links": [
          "https://www.programiz.com/python-programming/operators",
          "https://www.geeksforgeeks.org/python-operators/"
        ]
      },
      {
        "title": "2.3 Условные конструкции: if, elif, else.",
        "links": [
          "https://www.w3schools.com/python/python_conditions.asp",
          "https://realpython.com/python-conditional-statements/"
        ]
      },
      {
        "title": "2.4 Циклы: for, while, и команды break, continue.",
        "links": [
          "https://www.w3schools.com/python/python_for_loops.asp",
          "https://realpython.com/python-loops/"
        ]
      },
      {
        "title": "2.5 Списки и кортежи: создание, модификация, итерация.",
        "links": [
          "https://realpython.com/python-lists-tuples/",
          "https://www.w3schools.com/python/python_lists.asp"
        ]
      }
    ]
  },
  {
    "title": "3. Поглублённое изучение (недели 5–8)",
    "topics": [
      {
        "title": "3.1 Функции: создание, передача параметров, возврат значений.",
        "links": [
          "https://www.w3schools.com/python/python_functions.asp",
          "https://realpython.com/defining-your-own-python-function/"
        ]
      },
      {
        "title": "3.2 Модули и библиотеки: импорт, работа с модулями (напр., math, random, datetime).",
        "links": [
          "https://www.w3schools.com/python/python_modules.asp",
          "https://realpython.com/python-modules-packages/"
        ]
      },
      {
        "title": "3.3 Строки: методы работы с строками, форматирование.",
        "links": [
          "https://realpython.com/python-strings/",
          "https://www.w3schools.com/python/python_strings_methods.asp"
        ]
      },
      {
        "title": "3.4 Словари и наборы: основные операции.",
        "links": [
          "https://realpython.com/python-dicts/",
          "https://www.w3schools.com/python/python_dictionaries.asp"
        ]
      }
    ]
  },
  {
    "title": "4. Основы объектно-ориентированного программирования (недели 9–12)",
    "topics": [
      {
        "title": "4.1 Понятие классов и объектов.",
        "links": [
          "https://realpython.com/python3-object-oriented-programming/",
          "https://www.w3schools.com/python/python_classes.asp"
        ]
      },
      {
        "title": "4.2 Создание классов, методы, конструктор __init__.",
        "links": [
          "https://realpython.com/python-class-constructor/",
          "https://www.programiz.com/python-programming/class"
        ]
      },
      {
        "title": "4.3 Наследование и инкапсуляция.",
        "links": [
          "https://realpython.com/inheritance-composition-python/",
          "https://www.w3schools.com/python/python_inheritance.asp"
        ]
      },
      {
        "title": "4.4 Работа с методами и модулями ООП.",
        "links": [
          "https://www.tutorialspoint.com/python/python_classes_objects.htm",
          "https://realpython.com/python-oop/"
        ]
      }
    ]
  },
  {
    "title": "5. Реальные задачи (недели 13–16)",
    "topics": [
      {
        "title": "5.1 Файлы и потоки: чтение, запись, поиск и обработка данных.",
        "links": [
          "https://realpython.com/read-write-files-python/",
          "https://www.w3schools.com/python/python_file_handling.asp"
        ]
      },
      {
        "title": "5.2 Работа с API: запросы, получение данных, JSON.",
        "links": [
          "https://realpython.com/api-integration-in-python/",
          "https://docs.python-requests.org/en/latest/"
        ]
      },
      {
        "title": "5.3 Основы работы с базами данных (напр., SQLite).",
        "links": [
          "https://realpython.com/python-sql-libraries/",
          "https://www.sqlitetutorial.net/sqlite-python/"
        ]
      },
      {
        "title": "5.4 Мини-проекты (то-ду список, парсинг данных из сайтов).",
        "links": [
          "https://realpython.com/python-gui-tkinter/",
          "https://realpython.com/beautiful-soup-web-scraper-python/"
        ]
      }
    ]
  },
  {
    "title": "6. Расширение знаний (недели 17–20)",
    "topics": [
      {
        "title": "6.1 Работа с более сложными библиотеками (напр., NumPy, pandas).",
        "links": [
          "https://realpython.com/numpy-array-programming/",
          "https://realpython.com/pandas-python-explore-dataset/"
        ]
      },
      {
        "title": "6.2 Визуализация данных (напр., matplotlib, seaborn).",
        "links": [
          "https://realpython.com/python-matplotlib-guide/",
          "https://seaborn.pydata.org/"
        ]
      },
      {
        "title": "6.3 Основы работы с веб-разработкой (напр., Flask, Django).",
        "links": [
          "https://flask.palletsprojects.com/en/2.3.x/",
          "https://www.djangoproject.com/start/"
        ]
      },
      {
        "title": "6.4 Оптимизация кода и рефакторинг.",
        "links": [
          "https://realpython.com/python-refactoring/",
          "https://towardsdatascience.com/6-python-code-optimization-tips-89ea3e4b9ad5"
        ]
      }
    ]
  },
  {
    "title": "7. Финальный проект (недели 21–24)",
    "topics": [
      {
        "title": "7.1 Выбор проекта (веб-приложение, автоматизация задач, анализ данных).",
        "links": [
          "https://realpython.com/tutorials/beginner/#projects",
          "https://towardsdatascience.com/10-python-projects-for-beginners-2022-65a3d1e03363"
        ]
      },
      {
        "title": "7.2 Планирование и этапы разработки.",
        "links": [
          "https://realpython.com/python-project-planning/",
          "https://code.tutsplus.com/articles/how-to-plan-your-python-project--cms-32003"
        ]
      },
      {
        "title": "7.3 Реализация проекта.",
        "links": [
          "https://realpython.com/tutorials/intermediate/#projects",
          "https://medium.com/swlh/python-project-structure-best-practices-2020-22d0da899d67"
        ]
      },
      {
        "title": "7.4 Проверка, отладка и презентация.",
        "links": [
          "https://realpython.com/python-debugging-pdb/",
          "https://medium.com/pythonland/the-art-of-python-debugging-7e8545f4a965"
        ]
      }
    ]
  }
];

