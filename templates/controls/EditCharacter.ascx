<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditCharacter.ascx.cs" Inherits="RolePlayersGuild.templates.controls.EditCharacter" ClientIDMode="Static" %>
<script src="/js/jquery.are-you-sure.js"></script>
<script src="/js/ays-beforeunload-shim.js"></script>
<script>
    $(function () {
        // Example 1 - ... in one line of code
        $('#form1').areYouSure();
    });
    <%--    $(document).ready(function () {
        $('#<%= cblGenres.ClientID %> input[type=checkbox]').change(
        function () {
            var GenreList = '';
            $('#<%= cblGenres.ClientID %> input:checked').each(function () {
                GenreList += $(this).next('label').text() + ', ';
            });
            $('#spnGenreList').text(GenreList.slice(0, -2));
        });
    });--%>
</script>
<asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
    <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
</asp:Panel>
<h1>
    <asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <a class="btn btn-default" href="/My-Characters/">Back to My Characters</a>
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <asp:HyperLink runat="server" ID="lnkAddPhoto" NavigateUrl="#" Visible="false" CssClass="btn btn-success">
            <span class="glyphicon glyphicon-plus"></span>
            New Image</asp:HyperLink>
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <a runat="server" id="aCustomizeProfile" visible="false" class="btn btn-default" href="#">Customize Profile</a>
    </div>
</div>

<div class="form-group">
    <label for="txtDisplayName">Display Name</label>
    <asp:TextBox ID="txtDisplayName" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Display Name (Required)" required autofocus MaxLength="50"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvDisplayName" SetFocusOnError="true" runat="server" ErrorMessage="You must enter a display name." ControlToValidate="txtDisplayName" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
</div>
<div class="form-group">
    <label for="txtCharacterFirstName">Full Name</label>
    <div class="form-inline">
        <label for="txtCharacterFirstName" class="sr-only">First Name</label>
        <asp:TextBox ID="txtCharacterFirstName" runat="server" CssClass="form-control" placeholder="First Name (Required)" required MaxLength="50"></asp:TextBox>
        <label for="txtCharacterMiddleName" class="sr-only">Middle Name</label>
        <asp:TextBox ID="txtCharacterMiddleName" runat="server" CssClass="form-control" placeholder="Middle Name" MaxLength="50"></asp:TextBox>
        <label for="txtCharacterLastName" class="sr-only">Last Name</label>
        <asp:TextBox ID="txtCharacterLastName" runat="server" CssClass="form-control" placeholder="Last Name" MaxLength="50"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvCharacterFirstName" SetFocusOnError="true" runat="server" ErrorMessage="You must enter a first name." ControlToValidate="txtCharacterFirstName" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
    </div>
</div>
<div class="form-group">
    <label for="ddlGender">Character Gender</label>
    <asp:DropDownList ID="ddlGender" runat="server" ClientIDMode="Static" CssClass="form-control" AppendDataBoundItems="True" DataSourceID="sdsGenders" DataTextField="Gender" DataValueField="GenderID">
        <asp:ListItem Text="Choose One..." Value="--"></asp:ListItem>
    </asp:DropDownList>
    <asp:SqlDataSource ID="sdsGenders" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [GenderID], [Gender] FROM [Character_Genders] ORDER BY [GenderID]"></asp:SqlDataSource>
    <asp:RequiredFieldValidator ID="rfvGender" runat="server" SetFocusOnError="true" ErrorMessage="You must select a gender." ControlToValidate="ddlGender" InitialValue="--" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
</div>
<div class="form-group">
    <label for="ddlSexualOrientation">Sexual Orientation</label>
    <asp:DropDownList ID="ddlSexualOrientation" runat="server" ClientIDMode="Static" CssClass="form-control" AppendDataBoundItems="True" DataSourceID="sdsSexualOrientation" DataTextField="SexualOrientation" DataValueField="SexualOrientationID">
    </asp:DropDownList>
    <asp:SqlDataSource ID="sdsSexualOrientation" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [SexualOrientationID], [SexualOrientation] FROM [Character_SexualOrientations] ORDER BY [SexualOrientationID]"></asp:SqlDataSource>
</div>

<asp:Panel runat="server" ID="pnlProfileImage" class="form-group">
    <label for="fuCharacterProfileImage">Display Image</label>
    <asp:FileUpload ID="fuCharacterProfileImage" runat="server" />
    <p class="help-block">More images can be uploaded later. </p>
    <p class="help-block"><strong class="text-danger">NOTE:</strong> Please do <strong>not</strong> upload images with mature content. Violation of this rule may result in full account deletion without warning.</p>
</asp:Panel>
<div class="form-group">
    <label for="txtBackground">Character Details</label>
    <asp:TextBox ID="txtBackground" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" placeholder="Some backstory to your character. Don't give too much away, though, leave some for RP! You can also leave it blank, if you want." Rows="12" ValidateRequestMode="Disabled"></asp:TextBox>
</div>
<%--<div class="form-group">
    <label for="txtRecentEvents">Recent Events</label>
    <asp:TextBox ID="txtRecentEvents" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" placeholder="What has your character been up to lately? Maybe make some points that could trigger new Role-Plays." ValidateRequestMode="Disabled" Rows="12"></asp:TextBox>
</div>
<div class="form-group">
    <label for="txtOtherInfo">Other Information</label>
    <asp:TextBox ID="txtOtherInfo" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" placeholder="Any other details that aren't considered part of an origin story or recent events." ValidateRequestMode="Disabled" Rows="12"></asp:TextBox>
</div>--%>
<div class="form-group clearfix">
    <label for="cblGenres">Genres</label>
    <%--    <a href="#" class="btn btn-default" data-toggle="modal" data-target="#GenreList">Select Genres</a>
    <span id="spnGenreList" runat="server" clientidmode="Static"></span>--%>
    <div class="FancyCheckList GenreList">
        <asp:CheckBoxList ID="cblGenres" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsGenres" DataTextField="GenreName" DataValueField="GenreID" CssClass="FancyCheck" OnDataBound="cblGenres_DataBound"></asp:CheckBoxList>
        <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Genres] ORDER BY [GenreName]"></asp:SqlDataSource>
    </div>
</div>

<div class="form-group">
    <label for="ddlSource">Character Source</label>
    <div class="input-group">
        <asp:DropDownList ID="ddlSource" runat="server" CssClass="form-control">
            <asp:ListItem Text="Fan-Fic" Value="2"></asp:ListItem>
            <asp:ListItem Text="Non-Canon" Value="3"></asp:ListItem>
            <asp:ListItem Text="Original" Value="1"></asp:ListItem>
        </asp:DropDownList>
        <span class="input-group-btn">
            <a href="#" data-toggle="modal" data-target="#SourceDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
        </span>
    </div>

</div>

<div class="form-group">
    <label for="ddlPostLengthMinimum">Min Post Length</label>
    <div class="input-group">
        <asp:DropDownList ID="ddlPostLengthMinimum" runat="server" CssClass="form-control" DataSourceID="sdsPostLengths" DataTextField="PostLength" DataValueField="PostLengthID">
        </asp:DropDownList>
        <asp:SqlDataSource ID="sdsPostLengths" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [PostLengthID], [PostLength] FROM [Character_PostLengths] ORDER BY [PostLengthID]"></asp:SqlDataSource>
        <span class="input-group-btn">
            <a href="#" data-toggle="modal" data-target="#PostLengthDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
        </span>
    </div>

</div>
<div class="form-group">
    <label for="ddlPostLengthMaximum">Max Post Length</label>
    <div class="input-group">
        <asp:DropDownList ID="ddlPostLengthMaximum" runat="server" CssClass="form-control" DataSourceID="sdsPostLengths" DataTextField="PostLength" DataValueField="PostLengthID">
        </asp:DropDownList>
        <span class="input-group-btn">
            <a href="#" data-toggle="modal" data-target="#PostLengthDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
        </span>
    </div>
</div>
<div class="form-group">
    <label for="ddlLiteracyLevel">Preferred Literacy Level</label>
    <div class="input-group">
        <asp:DropDownList ID="ddlLiteracyLevel" runat="server" CssClass="form-control" DataSourceID="sdsLiteracyLevels" DataTextField="LiteracyLevel" DataValueField="LiteracyLevelID">
        </asp:DropDownList>
        <asp:SqlDataSource ID="sdsLiteracyLevels" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [LiteracyLevelID], [LiteracyLevel] FROM [Character_LiteracyLevels] ORDER BY [LiteracyLevelID]"></asp:SqlDataSource>
        <span class="input-group-btn">
            <a href="#" data-toggle="modal" data-target="#LiteracyLevelDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
        </span>
    </div>
</div>
<div class="form-group">
    <label for="ddlLiteracyLevel">Role-Play Contact Preference</label>
    <div class="input-group">
        <asp:DropDownList ID="ddlLFRP" runat="server" CssClass="form-control" DataSourceID="sdsLFRP" DataTextField="LFRPStatus" DataValueField="LFRPStatusID">
        </asp:DropDownList>
        <asp:SqlDataSource ID="sdsLFRP" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [LFRPStatusID], [LFRPStatus] FROM [Character_LFRPStatuses] ORDER BY [LFRPStatus]"></asp:SqlDataSource>
        <span class="input-group-btn">
            <a href="#" data-toggle="modal" data-target="#LFRPDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
        </span>
    </div>
</div>
<div class="form-group">
    <label for="ddlEroticaPreferences">Erotica Preferences</label>
    <asp:DropDownList ID="ddlEroticaPreferences" runat="server" ClientIDMode="Static" CssClass="form-control" AppendDataBoundItems="True" DataSourceID="sdsEroticaPreferences" DataTextField="EroticaPreference" DataValueField="EroticaPreferenceID">
    </asp:DropDownList>
    <asp:SqlDataSource ID="sdsEroticaPreferences" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [EroticaPreferenceID], [EroticaPreference] FROM [Character_EroticaPreferences] ORDER BY [EroticaPreferenceID]"></asp:SqlDataSource>
</div>

<label for="chkMatureContent">Mature Content?</label>

<div class="checkbox FancyCheck">
    <asp:CheckBox ID="chkMatureContent" ClientIDMode="Static" runat="server" Text="This Profile, its Gallery, or the Role-Play that comes from it may contain mature content." />
</div>
<div class="checkbox FancyCheck">
    <asp:CheckBox ID="chkPrivateCharacter" ClientIDMode="Static" runat="server" Text="This Character should not be linked to my Writer Profile." />
</div>
<div class="checkbox FancyCheck">
    <asp:CheckBox ID="chkDisableLinkify" ClientIDMode="Static" runat="server" Text="Disable auto-spacing and linking." />
</div>

<div class="form-group">
    <label for="ddlBadgesToAssign">Assign Badge</label>
    <asp:DropDownList ID="ddlBadgesToAssign" runat="server" ClientIDMode="Static" CssClass="form-control" AppendDataBoundItems="true" DataSourceID="sdsBadgesToAssign" DataTextField="BadgeName" DataValueField="UserBadgeID" OnDataBound="ddlBadgesToAssign_DataBound">
        <asp:ListItem Text="No Badge" Value="0"></asp:ListItem>
    </asp:DropDownList>
    <asp:SqlDataSource ID="sdsBadgesToAssign" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Badges.BadgeName, User_Badges.UserBadgeID FROM Badges INNER JOIN User_Badges ON Badges.BadgeID = User_Badges.BadgeID WHERE (User_Badges.UserID = @UserID) AND Badges.CharacterAssignable = 1 AND (User_Badges.AssignedToCharacterID = 0 OR User_Badges.AssignedToCharacterID = @CharacterID) ORDER BY DateReceived DESC">
        <SelectParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" />
            <asp:QueryStringParameter Name="CharacterID" QueryStringField="CharID" />
        </SelectParameters>
    </asp:SqlDataSource>
</div>


<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <asp:HyperLink ID="lnkDeleteCharacter" runat="server" Text="Delete Character" CssClass="btn btn-danger" data-toggle="modal" data-target="#DeleteCharacterModal" />
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <asp:Button ID="btnCreateCharacter" runat="server" Text="Save Character" CssClass="btn btn-primary" OnClick="btnCreateCharacter_Click" />
    </div>
</div>

<!-- Modals -->
<div class="modal fade" id="GenreList" tabindex="-1" role="dialog" aria-labelledby="GenreListLabel">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="GenreListLabel">Select Genres</h4>
            </div>
            <div class="modal-body FancyCheckList">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="PostLengthDescription" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="PostLengthDescriptionLabel">Post Lengths</h4>
            </div>
            <div class="modal-body">
                <p>In Role-Play there are a widely accepted set of terms to define post lengths. Remember, post lengths do <strong>not</strong> define the writing skills of a writer, but instead reflect the style of role-play a writer prefers. Post lengths can be defined as so:</p>
                <ul>
                    <li><strong>One-Line:</strong>
                        1-2 sentence per post.
                        <ul>
                            <li>One-Line RPs generally move very quickly. They're easy to respond and give the finest level of control-per-action, allowing writers to role-play without every havin to assume or propose paths for other writers' characters to follow.</li>
                        </ul>
                    </li>
                    <li><strong>Semi-Para:</strong>
                        3-4 sentences per post.
                        <ul>
                            <li>Similar to One-Line RPs, Semi-Para can move very quickly and be easy to respond to. Posts of this length can be often used to describe small actions that may need more description.</li>
                        </ul>
                    </li>
                    <li><strong>Para:</strong>
                        1 paragraph per post.
                        <ul>
                            <li>Para RP styles generally can vary in speed sometimes this style can move a RP quickly and other times they need a bit more time for replies. These can generally be fairly descriptive but not overbearingly so.</li>
                        </ul>
                    </li>
                    <li><strong>Multi-Para:</strong>
                        2-4 paragraphs per post.
                        <ul>
                            <li>Multi-Para RP generally requires writers to focus a bit more than others for each post. These are often detailed and sometimes immerssive in style. Some Multi-Para RPs can move a bit slowly, due to the more length post sizes. These RP posts can often cover one detailed action or multiple actions along with small assumptions of reactions.</li>
                        </ul>
                    </li>
                    <li><strong>Novella:</strong>
                        5+ paragraphs per post.
                        <ul>
                            <li>Novella posts are generally reserved for starters, setting changes or detailed character introductions, however some writers can stick to the Novella length for many posts at a time. Novella posts are almost always immersive and very detailed. They generally cover multiple actions and can be filled with various reaction assumptions along with multiple outcome routes for each assumption.</li>
                        </ul>
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="LFRPDescription" tabindex="-1" role="dialog" aria-labelledby="LFRPDescriptionLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="LFRPDescriptionLabel">LFRP Preferences</h4>
            </div>
            <div class="modal-body">
                <ul>
                    <li><strong>Okay with Discussions or Starters:</strong>
                        This means you're okay with getting random starters or discussion requests.
                    </li>
                    <li><strong>Initial Discussion Preferred:</strong>
                        This means you prefer for people to message you first to discuss stories.</li>
                    <li><strong>Spontaneous Starters Preferred:</strong>
                        This means you don't care for the discussion process and prefer to dive right into RP.</li>
                    <li><strong>Not Looking For Role-Plays:</strong>
                        This means you'd prefer not to start any new role-plays at this moment.</li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="LiteracyLevelDescription" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="LiteracyLevelDescriptionLabel">Literacy Levels</h4>
            </div>
            <div class="modal-body">
                <p>Literacy levels can be defined as so:</p>
                <ul>
                    <li><strong>Low:</strong>
                        Just here for fun, don't really care if you're the next Tolkien or not.</li>
                    <li><strong>Average:</strong>
                        As long as you can get a passing grade on a writing test in high school, we're good to go.</li>
                    <li><strong>High:</strong>
                        Keep errors to a minimum, please.</li>
                    <li><strong>Extreme:</strong>
                        Please make sure you're not making errors and you are proofreading your work.</li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="SourceDescription" tabindex="-1" role="dialog" aria-labelledby="SourceLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="SourceLabel">Character Sources</h4>
            </div>
            <div class="modal-body">
                <p>Character sources can be defined as so:</p>
                <ul>
                    <li><strong>Fan-Fic:</strong>
                        Characters that the writer did not originally create.
                    </li>
                    <li><strong>Non-Canon:</strong>
                        Characters that may be original creations of the writer but are based on the universe and rules of an existing work owned/created by someone else.
                    </li>
                    <li><strong>Original:</strong>
                        Characters that are completely original creations of the writer and don't belong to any universe created by anyone else.
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="DeleteCharacterModal" tabindex="-1" role="dialog" aria-labelledby="DeleteCharacterLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content alert-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="DeleteCharacterLabel">Are you sure?</h4>
            </div>
            <div class="modal-body">
                <p>Doing this will delete this character and all information tied to it. This will also remove the character from all threads without notice.</p>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnDeleteCharacter" runat="server" Text="Delete Character" CssClass="btn btn-danger" OnClick="btnDeleteCharacter_Click" />

                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>
<%--<div class="modal fade" id="NavigationWarningModal" tabindex="-1" role="dialog" aria-labelledby="NavigationWarningLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content alert-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="NavigationWarningLabel">Are you sure?</h4>
            </div>
            <div class="modal-body">
                <p>You have unsaved changes on this page. Are you certain you want to navigate elsewhere?</p>
            </div>
            <div class="modal-footer">
                <a href="#"></a>

                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>--%>
