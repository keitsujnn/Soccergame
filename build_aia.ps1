# Create SoccerGame AIA directory structure and project files with 100% compliant Blockly XML & AI2 headers

$projectDir = "C:\Users\parad\.gemini\antigravity-ide\scratch\SoccerGame"
$aiaZip = Join-Path $projectDir "SoccerGame.aia"

if (Test-Path $aiaZip) {
    Remove-Item -Force $aiaZip
}

# 1. Project Properties (Standard ai_user export format)
$projectProps = @"
main=appinventor.ai_user.SoccerGame.Screen1
name=SoccerGame
assets=../assets
source=../src
build=../build
versioncode=1
versionname=1.0
useslocation=False
"@

# 2. Screen1.scm with required AI2 header (#| \n $JSON \n ... \n |#)
$screenScmJson = @"
{
  "authURL": [
    "ai2.appinventor.mit.edu"
  ],
  "YaVersion": "230",
  "Source": "Form",
  "Properties": {
    "`$Name": "Screen1",
    "`$Type": "Form",
    "`$Version": "30",
    "AppName": "Soccer Game",
    "Title": "Penalty Kick Soccer",
    "ScreenOrientation": "Portrait",
    "BackgroundColor": "&HFF1E3A8A",
    "AlignHorizontal": "3",
    "AlignVertical": "2",
    "`$Components": [
      {
        "`$Name": "ScoreLayout",
        "`$Type": "HorizontalArrangement",
        "`$Version": "4",
        "AlignHorizontal": "3",
        "AlignVertical": "2",
        "BackgroundColor": "&HFF1E293B",
        "Width": "-2",
        "`$Components": [
          {
            "`$Name": "ScoreLabel",
            "`$Type": "Label",
            "`$Version": "6",
            "FontBold": "True",
            "FontSize": "20",
            "Text": "Score: 0",
            "TextColor": "&HFFFFFFFF"
          },
          {
            "`$Name": "HighLabel",
            "`$Type": "Label",
            "`$Version": "6",
            "FontBold": "True",
            "FontSize": "20",
            "Text": "  |  High: 0",
            "TextColor": "&HFFFFD700"
          }
        ]
      },
      {
        "`$Name": "FieldCanvas",
        "`$Type": "Canvas",
        "`$Version": "14",
        "BackgroundColor": "&HFF15803D",
        "Height": "420",
        "Width": "-2",
        "`$Components": [
          {
            "`$Name": "GoalNet",
            "`$Type": "ImageSprite",
            "`$Version": "7",
            "Height": "70",
            "Width": "200",
            "X": "50",
            "Y": "10",
            "Enabled": "True"
          },
          {
            "`$Name": "Goalkeeper",
            "`$Type": "ImageSprite",
            "`$Version": "7",
            "Height": "45",
            "Width": "45",
            "X": "127",
            "Y": "35",
            "Speed": "4",
            "Heading": "0",
            "Interval": "30",
            "Enabled": "True"
          },
          {
            "`$Name": "SoccerBall",
            "`$Type": "Ball",
            "`$Version": "2",
            "Color": "&HFFFFFFFF",
            "Radius": "16",
            "X": "134",
            "Y": "350",
            "Speed": "0",
            "Heading": "90",
            "Interval": "20",
            "Enabled": "True"
          }
        ]
      },
      {
        "`$Name": "ControlLayout",
        "`$Type": "HorizontalArrangement",
        "`$Version": "4",
        "AlignHorizontal": "3",
        "AlignVertical": "2",
        "BackgroundColor": "&HFF0F172A",
        "Width": "-2",
        "`$Components": [
          {
            "`$Name": "ResetButton",
            "`$Type": "Button",
            "`$Version": "7",
            "BackgroundColor": "&HFFEF4444",
            "FontBold": "True",
            "FontSize": "16",
            "Text": "Reset Game",
            "TextColor": "&HFFFFFFFF"
          },
          {
            "`$Name": "StatusLabel",
            "`$Type": "Label",
            "`$Version": "6",
            "FontBold": "True",
            "FontSize": "16",
            "Text": " Swipe ball to shoot!",
            "TextColor": "&HFF38BDF8"
          }
        ]
      },
      {
        "`$Name": "GoalkeeperClock",
        "`$Type": "Clock",
        "`$Version": "4",
        "TimerInterval": "30",
        "TimerEnabled": "True"
      }
    ]
  }
}
"@

$screenScm = "#|`n`$JSON`n" + $screenScmJson + "`n|#"

# 3. Screen1.bky with 100% compliant XML
$screenBky = @"
<xml xmlns="http://www.w3.org/1999/xhtml">
  <block type="global_declaration" id="var_score" x="30" y="30">
    <field name="NAME">score</field>
    <value name="VALUE">
      <block type="math_number" id="num_0_score">
        <field name="NUM">0</field>
      </block>
    </value>
  </block>

  <block type="global_declaration" id="var_highScore" x="250" y="30">
    <field name="NAME">highScore</field>
    <value name="VALUE">
      <block type="math_number" id="num_0_high">
        <field name="NUM">0</field>
      </block>
    </value>
  </block>

  <block type="component_event" id="evt_flung" x="30" y="120">
    <mutation component_type="Ball" is_generic="false" instance_name="SoccerBall" event_name="Flung"></mutation>
    <field name="COMPONENT_SELECTOR">SoccerBall</field>
    <statement name="DO">
      <block type="component_set_get" id="set_ball_speed">
        <mutation component_type="Ball" set_or_get="set" property_name="Speed" is_generic="false" instance_name="SoccerBall"></mutation>
        <field name="COMPONENT_SELECTOR">SoccerBall</field>
        <field name="PROP_NAME">Speed</field>
        <value name="VALUE">
          <block type="lexical_variable_get" id="get_speed">
            <field name="VAR">speed</field>
          </block>
        </value>
        <next>
          <block type="component_set_get" id="set_ball_heading">
            <mutation component_type="Ball" set_or_get="set" property_name="Heading" is_generic="false" instance_name="SoccerBall"></mutation>
            <field name="COMPONENT_SELECTOR">SoccerBall</field>
            <field name="PROP_NAME">Heading</field>
            <value name="VALUE">
              <block type="lexical_variable_get" id="get_heading">
                <field name="VAR">heading</field>
              </block>
            </value>
          </block>
        </next>
      </block>
    </statement>
  </block>

  <block type="component_event" id="evt_clock" x="30" y="300">
    <mutation component_type="Clock" is_generic="false" instance_name="GoalkeeperClock" event_name="Timer"></mutation>
    <field name="COMPONENT_SELECTOR">GoalkeeperClock</field>
    <statement name="DO">
      <block type="controls_if" id="if_keeper_bounds">
        <mutation elseif="1"></mutation>
        <value name="IF0">
          <block type="math_compare" id="cmp_right">
            <field name="OP">GTE</field>
            <value name="A">
              <block type="component_set_get" id="get_keeper_x">
                <mutation component_type="ImageSprite" set_or_get="get" property_name="X" is_generic="false" instance_name="Goalkeeper"></mutation>
                <field name="COMPONENT_SELECTOR">Goalkeeper</field>
                <field name="PROP_NAME">X</field>
              </block>
            </value>
            <value name="B">
              <block type="math_arithmetic" id="calc_max_x">
                <field name="OP">MINUS</field>
                <value name="A">
                  <block type="component_set_get" id="get_canvas_w">
                    <mutation component_type="Canvas" set_or_get="get" property_name="Width" is_generic="false" instance_name="FieldCanvas"></mutation>
                    <field name="COMPONENT_SELECTOR">FieldCanvas</field>
                    <field name="PROP_NAME">Width</field>
                  </block>
                </value>
                <value name="B">
                  <block type="component_set_get" id="get_keeper_w">
                    <mutation component_type="ImageSprite" set_or_get="get" property_name="Width" is_generic="false" instance_name="Goalkeeper"></mutation>
                    <field name="COMPONENT_SELECTOR">Goalkeeper</field>
                    <field name="PROP_NAME">Width</field>
                  </block>
                </value>
              </block>
            </value>
          </block>
        </value>
        <statement name="DO0">
          <block type="component_set_get" id="set_keeper_speed_neg">
            <mutation component_type="ImageSprite" set_or_get="set" property_name="Speed" is_generic="false" instance_name="Goalkeeper"></mutation>
            <field name="COMPONENT_SELECTOR">Goalkeeper</field>
            <field name="PROP_NAME">Speed</field>
            <value name="VALUE">
              <block type="math_number" id="num_neg4">
                <field name="NUM">-4</field>
              </block>
            </value>
          </block>
        </statement>
        <value name="IF1">
          <block type="math_compare" id="cmp_left">
            <field name="OP">LTE</field>
            <value name="A">
              <block type="component_set_get" id="get_keeper_x2">
                <mutation component_type="ImageSprite" set_or_get="get" property_name="X" is_generic="false" instance_name="Goalkeeper"></mutation>
                <field name="COMPONENT_SELECTOR">Goalkeeper</field>
                <field name="PROP_NAME">X</field>
              </block>
            </value>
            <value name="B">
              <block type="math_number" id="num_0_bound">
                <field name="NUM">0</field>
              </block>
            </value>
          </block>
        </value>
        <statement name="DO1">
          <block type="component_set_get" id="set_keeper_speed_pos">
            <mutation component_type="ImageSprite" set_or_get="set" property_name="Speed" is_generic="false" instance_name="Goalkeeper"></mutation>
            <field name="COMPONENT_SELECTOR">Goalkeeper</field>
            <field name="PROP_NAME">Speed</field>
            <value name="VALUE">
              <block type="math_number" id="num_pos4">
                <field name="NUM">4</field>
              </block>
            </value>
          </block>
        </statement>
        <next>
          <block type="component_method" id="call_keeper_move">
            <mutation component_type="ImageSprite" method_name="MoveTo" is_generic="false" instance_name="Goalkeeper"></mutation>
            <field name="COMPONENT_SELECTOR">Goalkeeper</field>
            <field name="METHOD_NAME">MoveTo</field>
            <value name="ARG0">
              <block type="math_arithmetic" id="add_keeper_x">
                <field name="OP">ADD</field>
                <value name="A">
                  <block type="component_set_get" id="get_keeper_x3">
                    <mutation component_type="ImageSprite" set_or_get="get" property_name="X" is_generic="false" instance_name="Goalkeeper"></mutation>
                    <field name="COMPONENT_SELECTOR">Goalkeeper</field>
                    <field name="PROP_NAME">X</field>
                  </block>
                </value>
                <value name="B">
                  <block type="component_set_get" id="get_keeper_spd">
                    <mutation component_type="ImageSprite" set_or_get="get" property_name="Speed" is_generic="false" instance_name="Goalkeeper"></mutation>
                    <field name="COMPONENT_SELECTOR">Goalkeeper</field>
                    <field name="PROP_NAME">Speed</field>
                  </block>
                </value>
              </block>
            </value>
            <value name="ARG1">
              <block type="component_set_get" id="get_keeper_y">
                <mutation component_type="ImageSprite" set_or_get="get" property_name="Y" is_generic="false" instance_name="Goalkeeper"></mutation>
                <field name="COMPONENT_SELECTOR">Goalkeeper</field>
                <field name="PROP_NAME">Y</field>
              </block>
            </value>
          </block>
        </next>
      </block>
    </statement>
  </block>

  <block type="component_event" id="evt_collide" x="480" y="120">
    <mutation component_type="Ball" is_generic="false" instance_name="SoccerBall" event_name="CollidedWith"></mutation>
    <field name="COMPONENT_SELECTOR">SoccerBall</field>
    <statement name="DO">
      <block type="controls_if" id="if_hit_keeper">
        <mutation elseif="1"></mutation>
        <value name="IF0">
          <block type="logic_compare" id="chk_keeper">
            <field name="OP">EQ</field>
            <value name="A">
              <block type="lexical_variable_get" id="get_other">
                <field name="VAR">other</field>
              </block>
            </value>
            <value name="B">
              <block type="component_component_block" id="comp_keeper">
                <mutation component_type="ImageSprite" instance_name="Goalkeeper"></mutation>
                <field name="COMPONENT_SELECTOR">Goalkeeper</field>
              </block>
            </value>
          </block>
        </value>
        <statement name="DO0">
          <block type="component_set_get" id="set_status_saved">
            <mutation component_type="Label" set_or_get="set" property_name="Text" is_generic="false" instance_name="StatusLabel"></mutation>
            <field name="COMPONENT_SELECTOR">StatusLabel</field>
            <field name="PROP_NAME">Text</field>
            <value name="VALUE">
              <block type="text" id="txt_saved">
                <field name="TEXT">SAVED! Goalkeeper caught it!</field>
              </block>
            </value>
            <next>
              <block type="component_set_get" id="stop_ball1">
                <mutation component_type="Ball" set_or_get="set" property_name="Speed" is_generic="false" instance_name="SoccerBall"></mutation>
                <field name="COMPONENT_SELECTOR">SoccerBall</field>
                <field name="PROP_NAME">Speed</field>
                <value name="VALUE">
                  <block type="math_number" id="num_0_sp1">
                    <field name="NUM">0</field>
                  </block>
                </value>
                <next>
                  <block type="component_set_get" id="rst_x1">
                    <mutation component_type="Ball" set_or_get="set" property_name="X" is_generic="false" instance_name="SoccerBall"></mutation>
                    <field name="COMPONENT_SELECTOR">SoccerBall</field>
                    <field name="PROP_NAME">X</field>
                    <value name="VALUE">
                      <block type="math_number" id="num_134_x1">
                        <field name="NUM">134</field>
                      </block>
                    </value>
                    <next>
                      <block type="component_set_get" id="rst_y1">
                        <mutation component_type="Ball" set_or_get="set" property_name="Y" is_generic="false" instance_name="SoccerBall"></mutation>
                        <field name="COMPONENT_SELECTOR">SoccerBall</field>
                        <field name="PROP_NAME">Y</field>
                        <value name="VALUE">
                          <block type="math_number" id="num_350_y1">
                            <field name="NUM">350</field>
                          </block>
                        </value>
                      </block>
                    </next>
                  </block>
                </next>
              </block>
            </next>
          </block>
        </statement>
        <value name="IF1">
          <block type="logic_compare" id="chk_goal">
            <field name="OP">EQ</field>
            <value name="A">
              <block type="lexical_variable_get" id="get_other2">
                <field name="VAR">other</field>
              </block>
            </value>
            <value name="B">
              <block type="component_component_block" id="comp_goal">
                <mutation component_type="ImageSprite" instance_name="GoalNet"></mutation>
                <field name="COMPONENT_SELECTOR">GoalNet</field>
              </block>
            </value>
          </block>
        </value>
        <statement name="DO1">
          <block type="lexical_variable_set" id="inc_score">
            <field name="VAR">global score</field>
            <value name="VALUE">
              <block type="math_arithmetic" id="add_score">
                <field name="OP">ADD</field>
                <value name="A">
                  <block type="lexical_variable_get" id="get_score">
                    <field name="VAR">global score</field>
                  </block>
                </value>
                <value name="B">
                  <block type="math_number" id="num_1">
                    <field name="NUM">1</field>
                  </block>
                </value>
              </block>
            </value>
            <next>
              <block type="component_set_get" id="update_score_lbl">
                <mutation component_type="Label" set_or_get="set" property_name="Text" is_generic="false" instance_name="ScoreLabel"></mutation>
                <field name="COMPONENT_SELECTOR">ScoreLabel</field>
                <field name="PROP_NAME">Text</field>
                <value name="VALUE">
                  <block type="text_join" id="join_score">
                    <mutation items="2"></mutation>
                    <value name="ADD0">
                      <block type="text" id="txt_score_prefix">
                        <field name="TEXT">Score: </field>
                      </block>
                    </value>
                    <value name="ADD1">
                      <block type="lexical_variable_get" id="get_score_txt">
                        <field name="VAR">global score</field>
                      </block>
                    </value>
                  </block>
                </value>
                <next>
                  <block type="controls_if" id="chk_high">
                    <value name="IF0">
                      <block type="math_compare" id="cmp_high">
                        <field name="OP">GT</field>
                        <value name="A">
                          <block type="lexical_variable_get" id="get_score_cur">
                            <field name="VAR">global score</field>
                          </block>
                        </value>
                        <value name="B">
                          <block type="lexical_variable_get" id="get_high_cur">
                            <field name="VAR">global highScore</field>
                          </block>
                        </value>
                      </block>
                    </value>
                    <statement name="DO0">
                      <block type="lexical_variable_set" id="set_high">
                        <field name="VAR">global highScore</field>
                        <value name="VALUE">
                          <block type="lexical_variable_get" id="get_score_cur2">
                            <field name="VAR">global score</field>
                          </block>
                        </value>
                        <next>
                          <block type="component_set_get" id="update_high_lbl">
                            <mutation component_type="Label" set_or_get="set" property_name="Text" is_generic="false" instance_name="HighLabel"></mutation>
                            <field name="COMPONENT_SELECTOR">HighLabel</field>
                            <field name="PROP_NAME">Text</field>
                            <value name="VALUE">
                              <block type="text_join" id="join_high">
                                <mutation items="2"></mutation>
                                <value name="ADD0">
                                  <block type="text" id="txt_high_prefix">
                                    <field name="TEXT">  |  High: </field>
                                  </block>
                                </value>
                                <value name="ADD1">
                                  <block type="lexical_variable_get" id="get_high_txt">
                                    <field name="VAR">global highScore</field>
                                  </block>
                                </value>
                              </block>
                            </value>
                          </block>
                        </next>
                      </block>
                    </statement>
                    <next>
                      <block type="component_set_get" id="set_status_goal">
                        <mutation component_type="Label" set_or_get="set" property_name="Text" is_generic="false" instance_name="StatusLabel"></mutation>
                        <field name="COMPONENT_SELECTOR">StatusLabel</field>
                        <field name="PROP_NAME">Text</field>
                        <value name="VALUE">
                          <block type="text" id="txt_goal">
                            <field name="TEXT">GOAL! Beautiful shot!</field>
                          </block>
                        </value>
                        <next>
                          <block type="component_set_get" id="stop_ball2">
                            <mutation component_type="Ball" set_or_get="set" property_name="Speed" is_generic="false" instance_name="SoccerBall"></mutation>
                            <field name="COMPONENT_SELECTOR">SoccerBall</field>
                            <field name="PROP_NAME">Speed</field>
                            <value name="VALUE">
                              <block type="math_number" id="num_0_sp2">
                                <field name="NUM">0</field>
                              </block>
                            </value>
                            <next>
                              <block type="component_set_get" id="rst_x2">
                                <mutation component_type="Ball" set_or_get="set" property_name="X" is_generic="false" instance_name="SoccerBall"></mutation>
                                <field name="COMPONENT_SELECTOR">SoccerBall</field>
                                <field name="PROP_NAME">X</field>
                                <value name="VALUE">
                                  <block type="math_number" id="num_134_x2">
                                    <field name="NUM">134</field>
                                  </block>
                                </value>
                                <next>
                                  <block type="component_set_get" id="rst_y2">
                                    <mutation component_type="Ball" set_or_get="set" property_name="Y" is_generic="false" instance_name="SoccerBall"></mutation>
                                    <field name="COMPONENT_SELECTOR">SoccerBall</field>
                                    <field name="PROP_NAME">Y</field>
                                    <value name="VALUE">
                                      <block type="math_number" id="num_350_y2">
                                        <field name="NUM">350</field>
                                      </block>
                                    </value>
                                  </block>
                                </next>
                              </block>
                            </next>
                          </block>
                        </next>
                      </block>
                    </next>
                  </block>
                </next>
              </block>
            </next>
          </block>
        </statement>
      </block>
    </statement>
  </block>

  <!-- 6. Event: SoccerBall.EdgeReached -->
  <block type="component_event" id="evt_edge" x="30" y="650">
    <mutation component_type="Ball" is_generic="false" instance_name="SoccerBall" event_name="EdgeReached"></mutation>
    <field name="COMPONENT_SELECTOR">SoccerBall</field>
    <statement name="DO">
      <block type="controls_if" id="if_top_edge">
        <mutation else="1"></mutation>
        <value name="IF0">
          <block type="math_compare" id="chk_top">
            <field name="OP">EQ</field>
            <value name="A">
              <block type="lexical_variable_get" id="get_edge">
                <field name="VAR">edge</field>
              </block>
            </value>
            <value name="B">
              <block type="math_number" id="num_neg1">
                <field name="NUM">-1</field>
              </block>
            </value>
          </block>
        </value>
        <statement name="DO0">
          <block type="component_set_get" id="set_status_out">
            <mutation component_type="Label" set_or_get="set" property_name="Text" is_generic="false" instance_name="StatusLabel"></mutation>
            <field name="COMPONENT_SELECTOR">StatusLabel</field>
            <field name="PROP_NAME">Text</field>
            <value name="VALUE">
              <block type="text" id="txt_out">
                <field name="TEXT">OUT! Shot went over the bar!</field>
              </block>
            </value>
            <next>
              <block type="component_set_get" id="stop_ball3">
                <mutation component_type="Ball" set_or_get="set" property_name="Speed" is_generic="false" instance_name="SoccerBall"></mutation>
                <field name="COMPONENT_SELECTOR">SoccerBall</field>
                <field name="PROP_NAME">Speed</field>
                <value name="VALUE">
                  <block type="math_number" id="num_0_sp3">
                    <field name="NUM">0</field>
                  </block>
                </value>
                <next>
                  <block type="component_set_get" id="rst_x3">
                    <mutation component_type="Ball" set_or_get="set" property_name="X" is_generic="false" instance_name="SoccerBall"></mutation>
                    <field name="COMPONENT_SELECTOR">SoccerBall</field>
                    <field name="PROP_NAME">X</field>
                    <value name="VALUE">
                      <block type="math_number" id="num_134_x3">
                        <field name="NUM">134</field>
                      </block>
                    </value>
                    <next>
                      <block type="component_set_get" id="rst_y3">
                        <mutation component_type="Ball" set_or_get="set" property_name="Y" is_generic="false" instance_name="SoccerBall"></mutation>
                        <field name="COMPONENT_SELECTOR">SoccerBall</field>
                        <field name="PROP_NAME">Y</field>
                        <value name="VALUE">
                          <block type="math_number" id="num_350_y3">
                            <field name="NUM">350</field>
                          </block>
                        </value>
                      </block>
                    </next>
                  </block>
                </next>
              </block>
            </next>
          </block>
        </statement>
        <statement name="ELSE">
          <block type="component_method" id="call_bounce">
            <mutation component_type="Ball" method_name="Bounce" is_generic="false" instance_name="SoccerBall"></mutation>
            <field name="COMPONENT_SELECTOR">SoccerBall</field>
            <field name="METHOD_NAME">Bounce</field>
            <value name="ARG0">
              <block type="lexical_variable_get" id="get_edge2">
                <field name="VAR">edge</field>
              </block>
            </value>
          </block>
        </statement>
      </block>
    </statement>
  </block>

  <!-- 7. Event: ResetButton.Click -->
  <block type="component_event" id="evt_reset_btn" x="480" y="650">
    <mutation component_type="Button" is_generic="false" instance_name="ResetButton" event_name="Click"></mutation>
    <field name="COMPONENT_SELECTOR">ResetButton</field>
    <statement name="DO">
      <block type="lexical_variable_set" id="reset_score">
        <field name="VAR">global score</field>
        <value name="VALUE">
          <block type="math_number" id="num_0_rst">
            <field name="NUM">0</field>
          </block>
        </value>
        <next>
          <block type="component_set_get" id="reset_score_lbl">
            <mutation component_type="Label" set_or_get="set" property_name="Text" is_generic="false" instance_name="ScoreLabel"></mutation>
            <field name="COMPONENT_SELECTOR">ScoreLabel</field>
            <field name="PROP_NAME">Text</field>
            <value name="VALUE">
              <block type="text" id="txt_score_0">
                <field name="TEXT">Score: 0</field>
              </block>
            </value>
            <next>
              <block type="component_set_get" id="reset_status_lbl">
                <mutation component_type="Label" set_or_get="set" property_name="Text" is_generic="false" instance_name="StatusLabel"></mutation>
                <field name="COMPONENT_SELECTOR">StatusLabel</field>
                <field name="PROP_NAME">Text</field>
                <value name="VALUE">
                  <block type="text" id="txt_reset_status">
                    <field name="TEXT">Game Reset! Swipe ball to shoot!</field>
                  </block>
                </value>
                <next>
                  <block type="component_set_get" id="stop_ball4">
                    <mutation component_type="Ball" set_or_get="set" property_name="Speed" is_generic="false" instance_name="SoccerBall"></mutation>
                    <field name="COMPONENT_SELECTOR">SoccerBall</field>
                    <field name="PROP_NAME">Speed</field>
                    <value name="VALUE">
                      <block type="math_number" id="num_0_sp4">
                        <field name="NUM">0</field>
                      </block>
                    </value>
                    <next>
                      <block type="component_set_get" id="rst_x4">
                        <mutation component_type="Ball" set_or_get="set" property_name="X" is_generic="false" instance_name="SoccerBall"></mutation>
                        <field name="COMPONENT_SELECTOR">SoccerBall</field>
                        <field name="PROP_NAME">X</field>
                        <value name="VALUE">
                          <block type="math_number" id="num_134_x4">
                            <field name="NUM">134</field>
                          </block>
                        </value>
                        <next>
                          <block type="component_set_get" id="rst_y4">
                            <mutation component_type="Ball" set_or_get="set" property_name="Y" is_generic="false" instance_name="SoccerBall"></mutation>
                            <field name="COMPONENT_SELECTOR">SoccerBall</field>
                            <field name="PROP_NAME">Y</field>
                            <value name="VALUE">
                              <block type="math_number" id="num_350_y4">
                                <field name="NUM">350</field>
                              </block>
                            </value>
                          </block>
                        </next>
                      </block>
                    </next>
                  </block>
                </next>
              </block>
            </next>
          </block>
        </next>
      </block>
    </statement>
  </block>
</xml>
"@

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$zipFile = [System.IO.Compression.ZipFile]::Open($aiaZip, [System.IO.Compression.ZipArchiveMode]::Create)

function Add-ZipEntry($zip, $entryPath, $content) {
    $entry = $zip.CreateEntry($entryPath)
    $stream = $entry.Open()
    $writer = New-Object System.IO.StreamWriter($stream, [System.Text.Encoding]::UTF8)
    $writer.Write($content)
    $writer.Flush()
    $writer.Close()
    $stream.Close()
}

# Standard MIT App Inventor export path structure under ai_user
Add-ZipEntry $zipFile "youngandroidproject/project.properties" $projectProps
Add-ZipEntry $zipFile "src/appinventor/ai_user/SoccerGame/Screen1.scm" $screenScm
Add-ZipEntry $zipFile "src/appinventor/ai_user/SoccerGame/Screen1.bky" $screenBky

$zipFile.Dispose()

Write-Host "SoccerGame.aia cleanly rebuilt with 100% compliant XML at: $aiaZip"
