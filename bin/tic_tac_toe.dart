import 'dart:io';
import 'dart:math';

void main() {
  while (true) {
    print('=== Крестики-нолики ===');
    
    print('1 - Два игрока\n2 - Против робота');
    final vsRobot = _input('Выбор', ['1', '2']) == '2';
    
    final n = int.parse(_input('Размер поля (3-5)', ['3', '4', '5']));
    
    _playGame(n, vsRobot);
    
    if (_input('Ещё раз? (y/n)', ['y', 'n']) == 'n') break;
    print('\n' * 3);
  }
}

void _playGame(int n, bool vsRobot) {
  var board = List.generate(n, (_) => List.filled(n, ' '));
  var player = Random().nextBool() ? 'X' : 'O';
  var moves = 0;

  while (true) {
    _printBoard(board);
    
    if (vsRobot && player == 'O') {
      final empty = [];
      for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
          if (board[i][j] == ' ') empty.add([i, j]);
        }
      }
      final move = empty[Random().nextInt(empty.length)];
      board[move[0]][move[1]] = 'O';
      print('Робот сходил: ${move[0] + 1} ${move[1] + 1}');
    } 
    else {
      print('Ход игрока $player');
      while (true) {
        final row = int.parse(_input('Строка (1-$n)', List.generate(n, (i) => '${i + 1}')));
        final col = int.parse(_input('Столбец (1-$n)', List.generate(n, (i) => '${i + 1}')));
        
        final i = row - 1;  
        final j = col - 1;
        
        if (board[i][j] == ' ') {
          board[i][j] = player;
          break;
        }
        print('Эта клетка уже занята!');
      }
    }
    
    moves++;
    
    if (_checkWin(board, player)) {
      _printBoard(board);
      print('$player ПОБЕДИЛ!');
      return;
    }
    
    if (moves == n * n) {
      _printBoard(board);
      print('НИЧЬЯ!');
      return;
    }
    
    player = player == 'X' ? 'O' : 'X';
  }
}

bool _checkWin(List<List<String>> board, String player) {
  final n = board.length;
  
  for (var i = 0; i < n; i++) {
    if (board[i].every((cell) => cell == player)) return true;
  }
  
  for (var j = 0; j < n; j++) {
    var win = true;
    for (var i = 0; i < n; i++) {
      if (board[i][j] != player) win = false;
    }
    if (win) return true;
  }
  
  var diag1 = true, diag2 = true;
  for (var i = 0; i < n; i++) {
    if (board[i][i] != player) diag1 = false;
    if (board[i][n - 1 - i] != player) diag2 = false;
  }
  
  return diag1 || diag2;
}

void _printBoard(List<List<String>> board) {
  final n = board.length;
  
  print('\n    ${List.generate(n, (i) => i + 1).join('   ')}');
  print('   ${'---' * n}');
  
  for (var i = 0; i < n; i++) {
    var row = '${i + 1} |';
    for (var j = 0; j < n; j++) {
      row += ' ${board[i][j]} |';
    }
    print(row);
    
    print('   ${'---' * n}');
  }
  print('');
}

String _input(String vvod, List<String> allowed) {
  while (true) {
    stdout.write('$vvod: ');
    final input = stdin.readLineSync()?.trim() ?? '';
    if (allowed.contains(input)) return input;
    print('Неверный ввод! Допустимо: ${allowed.join(", ")}');
  }
}