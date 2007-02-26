	<Button name="mrpOptionsShareA" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="18" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-17" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="A" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="18" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Always share this information.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<Button name="mrpOptionsShareP" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="18" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-17" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="P" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="18" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Prompt before sharing this information.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<Button name="mrpOptionsShareN" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="18" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-17" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="N" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="18" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Never share this information.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>

	

	<CheckButton name="mrpShareToggleOptionButton" parent="mrpOptionsPage2" toplevel="true" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="20" y="20"/>
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpUniversalFrame" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="58" y="-35" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentRelative" inherits="GameFontNormal" text="Share" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="200" y="11" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="18" y="-3" />
							</Offset>
						</Anchor>
					</Anchors>
				</FontString>
			</Layer>
		</Layers>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Toggle the sharing MyRolePlay information.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpOptionShareToggle()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionSharePrefixAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-29" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share prefix.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysPrefix()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionSharePrefixPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-29" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing prefix.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptPrefix()
				SetOptionsCheckButtons()

			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionSharePrefixNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-29" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share prefix.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverPrefix()
				SetOptionsCheckButtons()

			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsSharePrefix" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="18" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-29" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Prefix" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="50" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's prefix.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>

	<CheckButton name="mrpOptionShareFirstNameAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-41" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share first name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysFirstName()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareFirstNamePrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-41" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing first name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptFirstName()
				SetOptionsCheckButtons()

			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareFirstNameNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-41" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share first name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverFirstName()
				SetOptionsCheckButtons()

			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareFirstName" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-41" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="First name" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's first name.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>

	<CheckButton name="mrpOptionShareMiddleNameAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-53" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share middle name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysMiddleName()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareMiddleNamePrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-53" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing middle name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptMiddleName()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareMiddleNameNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-53" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share middle name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverMiddleName()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareMiddleName" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-53" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Middle name" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's middle name.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>

	<CheckButton name="mrpOptionShareSurnameAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-65" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share surname.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysSurname()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareSurnamePrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-65" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing surname.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptSurname()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareSurnameNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-65" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share surname.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverSurname()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareSurname" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-65" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Surname" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's surname.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>


	<CheckButton name="mrpOptionShareTitleAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-77" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share title.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysTitle()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareTitlePrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-77" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing title.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptTitle()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareTitleNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-77" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share title.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverTitle()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareTitle" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-77" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Title" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's title.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>

	<CheckButton name="mrpOptionShareNicknameAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-89" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share nickname.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysNickname()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareNicknamePrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-89" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing nickname.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptNickname()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareNicknameNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-89" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share nickname.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverNickname()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareNickname" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-89" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Nickname" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's nickname.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<CheckButton name="mrpOptionShareHouseNameAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-101" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share house name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysHouseName()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareHouseNamePrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-101" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing house name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptHouseName()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareHouseNameNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-101" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share house name.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverHouseName()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareHouseName" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-101" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="House name" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's house name.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<CheckButton name="mrpOptionShareEyeColourAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-113" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share eye colour.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysEyeColour()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareEyeColourPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-113" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing eye colour.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptEyeColour()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareEyeColourNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-113" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share eye colour.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverEyeColour()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareEyeColour" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-113" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Eye Colour" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's eye colour.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<CheckButton name="mrpOptionShareHeightAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-125" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share height.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysHeight()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareHeightPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-125" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing height.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptHeight()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareHeightNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-125" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share height.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverHeight()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareHeight" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-125" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Height" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's height.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<CheckButton name="mrpOptionShareWeightAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-137" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share weight.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysWeight()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareWeightPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-137" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing weight.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptWeight()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareWeightNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-137" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share weight.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverWeight()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareWeight" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-137" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Weight" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's weight.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>

	<CheckButton name="mrpOptionShareEmotionAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-149" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share emotion.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysEmotion()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareEmotionPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-149" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing emotion.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptEmotion()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareEmotionNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-149" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share emotion.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverEmotion()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareEmotion" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-149" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Emotion" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's emotion.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<CheckButton name="mrpOptionShareHomeCityAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-161" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share home city.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysHomeCity()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareHomeCityPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-161" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing home city.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptHomeCity()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareHomeCityNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-161" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share home city.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverHomeCity()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareHomeCity" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-161" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Home City" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's home city.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>

	<CheckButton name="mrpOptionShareBirthCityAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-173" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share birth city.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysBirthCity()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareBirthCityPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-173" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing birth city.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptBirthCity()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareBirthCityNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-173" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share birth city.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverBirthCity()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareBirthCity" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-173" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Birth City" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's birth city.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<CheckButton name="mrpOptionShareMottoAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-185" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share motto.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysMotto()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareMottoPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-185" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing motto.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptMotto()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareMottoNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-185" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share motto.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverMotto()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareMotto" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-185" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Motto" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's motto.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
	<CheckButton name="mrpOptionShareHistoryAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-197" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share history.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysHistory()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareHistoryPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-197" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing history.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptHistory()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareHistoryNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-197" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share history.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverHistory()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareHistory" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-197" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="History" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's history.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>

	<CheckButton name="mrpOptionShareGuildAlways" parent="mrpOptionsPage2" inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="17" y="-209" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Always share guild.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareAlwaysGuild()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareGuildPrompt" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="31" y="-209" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Prompt before sharing guild.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleSharePromptGuild()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>

	<CheckButton name="mrpOptionShareGuildNever" parent="mrpOptionsPage2"  inherits="OptionsCheckButtonTemplate" checked="true">
		<Size>
			<AbsDimension x="12" y="12" />
		</Size>
		<HitRectInsets>
			<AbsInset left="3" right="-3" top="3" bottom="3"/>
		</HitRectInsets>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="45" y="-209" />
				</Offset>
			</Anchor>
		</Anchors>

		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				GameTooltip:SetText("Never share guild.", 1.0, 1.0, 1.0, 0.5 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
			<OnClick>
				mrpToggleShareNeverGuild()
				SetOptionsCheckButtons()
			</OnClick>
		</Scripts>
	</CheckButton>
	<Button name="mrpOptionsShareGuild" parent="mrpOptionsPage2" toplevel="true" hidden="false">
		<Size>
			<AbsDimension x="100" y="12" />
		</Size>
		<Anchors>
			<Anchor point="TOPLEFT" relativeTo="mrpOptionsPage2" relativePoint="TOPLEFT">
				<Offset>
					<AbsDimension x="63" y="-209" />
				</Offset>
			</Anchor>
		</Anchors>
		<Layers>
			<Layer level="ARTWORK">
				<FontString name="$parentText" inherits="GameFontNormalSmall" text="Guild" justifyV="TOP" justifyH="LEFT">
					<Size>
						<AbsDimension x="100" y="12" />
					</Size>
					<Anchors>
						<Anchor point="TOPLEFT">
							<Offset>
								<AbsDimension x="0" y="0" />
							</Offset>
						</Anchor>
					</Anchors>>
					<Color r="1.0" g="0.8" b="0.0" />
				</FontString>
			</Layer>
		</Layers>
		<Scripts>
			<OnEnter>
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:SetText("Share your character's guild.", 1.0, 1.0, 1.0, 1 );
				GameTooltip:Show();
			</OnEnter>
			<OnLeave>
				GameTooltip:Hide();
			</OnLeave>
		</Scripts>
	</Button>
