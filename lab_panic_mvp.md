# Lab Panic — MVP

## 1. Visão Geral

**Lab Panic** é um jogo casual mobile desenvolvido em **Flutter**, no estilo arcade/puzzle, onde objetos geométricos caem do topo da tela e o jogador precisa arrastá-los para o recipiente correto antes que cheguem ao fim da área de jogo.

O tema visual será um **laboratório industrial futurista**, com aparência metálica, escura e tecnológica. A proposta é criar uma experiência simples, rápida e viciante, ideal para partidas curtas.

---

## 2. Conceito do Jogo

O jogador atua em um laboratório de testes automatizado, onde formas instáveis precisam ser separadas corretamente em recipientes específicos. Cada erro reduz uma vida e, conforme o tempo passa, a velocidade das formas aumenta, criando uma sensação de pressão e caos controlado.

### Frase do conceito

> **Organize as formas antes que o laboratório entre em colapso.**

---

## 3. Objetivo do MVP

Criar uma primeira versão jogável de **Lab Panic**, com as mecânicas principais funcionando:

- Formas caindo do topo da tela.
- Jogador podendo arrastar as formas.
- Recipientes corretos para cada tipo de forma.
- Validação de acerto e erro.
- Sistema de pontuação.
- Sistema de vidas.
- Aumento progressivo da dificuldade.
- Tela inicial, tela de jogo e tela de fim de partida.

O MVP deve ser simples, funcional e visualmente coerente com o tema definido.

---

## 4. Público-Alvo

O jogo é voltado para jogadores casuais que buscam partidas rápidas para passar o tempo.

### Perfil do jogador

- Pessoas que gostam de jogos simples e rápidos.
- Jogadores mobile casuais.
- Usuários que gostam de jogos de reflexo e atenção.
- Pessoas que preferem partidas curtas e progressivas.

---

## 5. Plataforma

### Plataforma principal

- Android

### Plataforma secundária futura

- iOS

### Orientação da tela

- Portrait / Retrato
- Proporção base: **9:16**

---

## 6. Stack Técnica

### Framework

- Flutter

### Linguagem

- Dart

### Gerenciamento de estado sugerido para o MVP

- `setState`
- ou `ValueNotifier`

Para o MVP, evitar complexidade desnecessária. Caso o projeto cresça, pode ser migrado para:

- Riverpod
- Bloc
- Provider

### Persistência local

Para o MVP:

- `shared_preferences`

Uso inicial:

- Salvar maior pontuação.
- Salvar preferências simples, caso necessário.

### Pacotes recomendados

```yaml
dependencies:
  flutter:
    sdk: flutter

  shared_preferences: ^2.2.3
```

Pacotes opcionais para versões futuras:

```yaml
dependencies:
  flame: ^1.17.0
  audioplayers: ^6.0.0
```

> Observação: o MVP pode ser feito sem Flame. Como a mecânica é simples, Flutter puro com `Stack`, `Positioned`, `GestureDetector` e `AnimationController` já é suficiente.

---

## 7. Identidade Visual

### Tema escolhido

**Laboratório Industrial**

O jogo deve parecer um laboratório de testes automatizado, com painéis metálicos, luzes de alerta, caixas industriais e efeitos de energia.

### Paleta de cores oficial

#### Cores base

| Uso | Hex |
|---|---|
| Fundo principal | `#0B0F14` |
| Fundo secundário | `#111827` |
| Superfície / Containers | `#1F2937` |
| Bordas metálicas | `#4B5563` |
| Texto principal | `#F9FAFB` |
| Texto secundário | `#CBD5E1` |

#### Cores das formas

| Forma | Cor | Hex |
|---|---|---|
| Círculo | Ciano técnico | `#06B6D4` |
| Quadrado | Amarelo industrial | `#F59E0B` |
| Triângulo | Vermelho alerta | `#EF4444` |

#### Cores de feedback

| Ação | Hex |
|---|---|
| Acerto | `#10B981` |
| Erro | `#DC2626` |
| Aviso | `#FBBF24` |
| Combo / Energia | `#3B82F6` |

### Classe de cores Flutter

```dart
import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0B0F14);
  static const backgroundSecondary = Color(0xFF111827);
  static const surface = Color(0xFF1F2937);
  static const border = Color(0xFF4B5563);

  static const textPrimary = Color(0xFFF9FAFB);
  static const textSecondary = Color(0xFFCBD5E1);

  static const circle = Color(0xFF06B6D4);
  static const square = Color(0xFFF59E0B);
  static const triangle = Color(0xFFEF4444);

  static const success = Color(0xFF10B981);
  static const error = Color(0xFFDC2626);
  static const warning = Color(0xFFFBBF24);
  static const combo = Color(0xFF3B82F6);
}
```

---

## 8. Mecânica Principal

### Formas disponíveis no MVP

- Círculo
- Quadrado
- Triângulo

### Recipientes disponíveis no MVP

- Recipiente do círculo
- Recipiente do quadrado
- Recipiente do triângulo

### Funcionamento

1. Uma forma aparece no topo da tela.
2. A forma começa a cair automaticamente.
3. O jogador arrasta a forma.
4. O jogador solta a forma sobre um recipiente.
5. O jogo verifica se o recipiente corresponde ao tipo da forma.
6. Se estiver correto:
   - A forma desaparece.
   - O jogador ganha pontos.
   - Um feedback visual de acerto é exibido.
7. Se estiver errado:
   - O jogador perde uma vida.
   - Um feedback visual de erro é exibido.
8. Se a forma chegar ao limite inferior sem ser organizada:
   - O jogador perde uma vida.
   - A forma desaparece.
9. O jogo continua até as vidas acabarem.

---

## 9. Loop de Gameplay

```text
Início da partida
↓
Gerar forma aleatória
↓
Forma cai
↓
Jogador arrasta forma
↓
Solta no recipiente
↓
Verificar acerto ou erro
↓
Atualizar pontuação / vidas
↓
Aumentar dificuldade gradualmente
↓
Repetir enquanto vidas > 0
↓
Fim de jogo
↓
Exibir pontuação final e melhor pontuação
```

---

## 10. Regras do MVP

### Pontuação

| Ação | Pontos |
|---|---:|
| Forma correta no recipiente certo | +100 |
| Combo de 3 acertos seguidos | +50 extra |
| Combo de 5 acertos seguidos | +100 extra |
| Erro | 0 |
| Forma perdida | 0 |

### Vidas

- O jogador começa com **3 vidas**.
- Cada erro reduz **1 vida**.
- Cada forma perdida reduz **1 vida**.
- Ao chegar em **0 vidas**, a partida termina.

### Dificuldade

A dificuldade aumenta com o tempo.

Sugestão para o MVP:

| Tempo de partida | Velocidade |
|---|---:|
| 0s a 20s | Baixa |
| 21s a 45s | Média |
| 46s a 75s | Alta |
| 76s+ | Muito alta |

Outra opção simples:

```dart
fallSpeed = baseSpeed + (score / 500) * speedIncrement;
```

### Geração de formas

No MVP, gerar apenas uma forma por vez.

Versões futuras podem ter:

- Duas formas simultâneas.
- Padrões de queda.
- Ondas de dificuldade.
- Formas especiais.

---

## 11. Telas do MVP

## 11.1. Splash Screen

Tela curta de apresentação.

### Elementos

- Logo ou nome **Lab Panic**
- Fundo do laboratório industrial
- Pequena animação ou brilho
- Transição automática para o menu

### Pode ser simplificada no MVP

Caso queira reduzir escopo, a Splash Screen pode ser ignorada na primeira versão.

---

## 11.2. Tela Inicial

### Elementos

- Nome do jogo: **Lab Panic**
- Botão **Jogar**
- Botão **Como jogar**
- Melhor pontuação
- Fundo com laboratório industrial

### Ações

- **Jogar** inicia a partida.
- **Como jogar** abre uma tela/modal de instruções.

---

## 11.3. Tela Como Jogar

### Conteúdo

Explicação simples:

> Arraste cada forma para o recipiente correto.  
> Círculos vão para o recipiente circular.  
> Quadrados vão para o recipiente quadrado.  
> Triângulos vão para o recipiente triangular.  
> Erros e formas perdidas reduzem vidas.

### Elementos

- Exemplo visual das três formas.
- Exemplo visual dos três recipientes.
- Botão **Voltar**.

---

## 11.4. Tela de Jogo

### Elementos principais

- Pontuação atual.
- Vidas.
- Área de queda das formas.
- Formas arrastáveis.
- Três recipientes na parte inferior.
- Feedback visual de acerto ou erro.
- Botão de pausa.

### Layout sugerido

```text
┌─────────────────────────────┐
│ Score              Vidas     │
│                             │
│        Área de queda         │
│                             │
│      formas caindo aqui      │
│                             │
│                             │
│  [Círculo] [Quadrado] [Tri]  │
└─────────────────────────────┘
```

---

## 11.5. Tela de Pausa

### Elementos

- Título: **Pausado**
- Botão **Continuar**
- Botão **Reiniciar**
- Botão **Sair para o menu**

---

## 11.6. Tela de Game Over

### Elementos

- Título: **Game Over**
- Pontuação final
- Melhor pontuação
- Botão **Jogar novamente**
- Botão **Menu inicial**

---

## 12. Componentes Principais

### `FallingShape`

Representa uma forma que cai na tela.

#### Campos sugeridos

```dart
class FallingShape {
  final String id;
  final ShapeType type;
  double x;
  double y;
  final double size;
  final double speed;
  bool isDragging;

  FallingShape({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    this.isDragging = false,
  });
}
```

---

### `ShapeType`

Enum para os tipos de forma.

```dart
enum ShapeType {
  circle,
  square,
  triangle,
}
```

---

### `ShapeContainer`

Representa um recipiente de destino.

```dart
class ShapeContainer {
  final ShapeType acceptedType;
  final Rect area;

  ShapeContainer({
    required this.acceptedType,
    required this.area,
  });
}
```

---

### `GameState`

Estado geral da partida.

```dart
enum GameStatus {
  menu,
  playing,
  paused,
  gameOver,
}
```

---

## 13. Estrutura de Pastas Recomendada

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── constants/
│       └── game_constants.dart
├── data/
│   └── local/
│       └── score_storage.dart
├── models/
│   ├── falling_shape.dart
│   ├── shape_type.dart
│   └── game_status.dart
├── screens/
│   ├── home_screen.dart
│   ├── game_screen.dart
│   ├── how_to_play_screen.dart
│   └── game_over_screen.dart
├── widgets/
│   ├── falling_shape_widget.dart
│   ├── shape_container_widget.dart
│   ├── score_panel.dart
│   ├── lives_panel.dart
│   └── industrial_button.dart
└── services/
    └── game_controller.dart
```

---

## 14. Assets Necessários para o MVP

### Obrigatórios

- Fundo principal do laboratório industrial.
- Ícone do app.
- Logo simples do jogo.
- Som de acerto.
- Som de erro.
- Som de game over.

### Opcionais no MVP

- Partículas de acerto.
- Partículas de erro.
- Animação de brilho nos recipientes.
- Música de fundo.
- Ícones personalizados para botões.

---

## 15. Prompt para Gerar o Fundo

```text
Design a 9:16 portrait mobile game background for a casual game called Lab Panic, with a futuristic industrial laboratory theme. Use a dark metallic environment with clean sci-fi details, polished steel panels, pipes, glowing lab chambers, warning stripes, control consoles, and subtle fog. Keep the center area clean for gameplay, with more detailed decoration on the sides. Use a palette based on #0B0F14, #111827, #1F2937, #4B5563, with accent glows in cyan #06B6D4, orange #F59E0B, red #EF4444, and blue #3B82F6. The atmosphere should feel high-tech, industrial, and slightly tense. No UI, no shapes, no containers, no text, no characters.
```

---

## 16. Prioridades do MVP

### Essencial

- [ ] Criar projeto Flutter.
- [ ] Definir tema visual.
- [ ] Criar tela inicial.
- [ ] Criar tela de jogo.
- [ ] Criar três tipos de forma.
- [ ] Fazer formas caírem.
- [ ] Permitir arrastar formas.
- [ ] Criar três recipientes.
- [ ] Validar acerto e erro.
- [ ] Criar sistema de vidas.
- [ ] Criar sistema de pontuação.
- [ ] Criar tela de game over.
- [ ] Salvar melhor pontuação.

### Importante

- [ ] Adicionar botão de pausa.
- [ ] Adicionar tela de instruções.
- [ ] Adicionar feedback visual de acerto.
- [ ] Adicionar feedback visual de erro.
- [ ] Ajustar dificuldade progressiva.

### Pode ficar para depois

- [ ] Loja de skins.
- [ ] Power-ups.
- [ ] Ranking online.
- [ ] Fases.
- [ ] Conquistas.
- [ ] Música de fundo.
- [ ] Sistema de missões diárias.

---

## 17. Primeira Versão Jogável

A primeira versão jogável deve conter apenas:

1. Tela inicial.
2. Botão para iniciar partida.
3. Tela de jogo.
4. Uma forma caindo por vez.
5. Arrastar e soltar.
6. Três recipientes.
7. Pontuação.
8. Vidas.
9. Game over.
10. Melhor pontuação salva.

---

## 18. Critérios de Aceite

O MVP será considerado funcional quando:

- O jogador conseguir iniciar uma partida.
- Uma forma aparecer e cair na tela.
- O jogador conseguir arrastar a forma.
- O jogo reconhecer quando a forma foi solta no recipiente correto.
- O jogo reconhecer quando a forma foi solta no recipiente errado.
- O jogo reduzir vida em caso de erro.
- O jogo reduzir vida se a forma cair até o fim da tela.
- O jogo somar pontos em caso de acerto.
- O jogo encerrar a partida ao chegar em 0 vidas.
- O jogo exibir a pontuação final.
- O jogo salvar e exibir a melhor pontuação.

---

## 19. Roadmap Pós-MVP

### Versão 1.1

- Sons de acerto e erro.
- Animações de feedback.
- Tela de pausa.
- Melhorias visuais nos recipientes.

### Versão 1.2

- Combos.
- Multiplicador de pontos.
- Dificuldade mais refinada.
- Mais efeitos visuais.

### Versão 1.3

- Power-ups.
- Forma congelante.
- Forma bomba.
- Forma bônus.

### Versão 1.4

- Missão diária.
- Desafio do dia.
- Histórico de pontuação.

### Versão 2.0

- Skins de laboratório.
- Loja cosmética.
- Ranking online.
- Conquistas.

---

## 20. Ideias de Power-ups Futuros

### Slow Motion

Reduz a velocidade das formas por alguns segundos.

### Magnet Container

Atrai a forma para o recipiente correto.

### Shield

Protege o jogador de um erro.

### Double Points

Dobra a pontuação por tempo limitado.

### Clear Screen

Remove todas as formas da tela.

---

## 21. Possíveis Modos Futuros

### Modo Infinito

O jogador joga até perder todas as vidas.

### Modo Tempo

O jogador tenta fazer a maior pontuação em 60 segundos.

### Modo Desafio Diário

Uma configuração fixa de velocidade e formas para todos os jogadores no dia.

### Modo Caos

Duas ou mais formas caem ao mesmo tempo.

---

## 22. Resumo do MVP

**Lab Panic** será um jogo mobile casual em Flutter onde o jogador precisa separar formas geométricas em recipientes corretos dentro de um laboratório industrial futurista.

O foco do MVP é entregar uma versão simples, jogável e visualmente agradável, com:

- Mecânica clara.
- Partidas rápidas.
- Feedback imediato.
- Dificuldade progressiva.
- Identidade visual consistente.
- Código organizado para evolução futura.
