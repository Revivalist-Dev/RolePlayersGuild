<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditThread.ascx.cs" Inherits="RolePlayersGuild.templates.controls.EditThread" %>
<script>
    function Closepopup() {
        $('#UserSearch').modal('hide');
    }
    function Closeotherpopup() {
        $('#RemoveCharacters').modal('hide');
    }
    function deactivateButton(theBtn) {
        $(theBtn).addClass("disabled");
        $(theBtn).text("Please Wait...");
    };
</script>
<h1>
    <asp:Literal ID="litMessageType" runat="server"></asp:Literal></h1>
<asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
    <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
</asp:Panel>
<asp:Panel ID="pnlThreadForm" runat="server" ClientIDMode="Static">
    <asp:Panel runat="server" ID="pnlTitle" class="form-group">
        <label for="txtThreadTitle">Thread Title</label>
        <asp:TextBox ID="txtThreadTitle" runat="server" CssClass="form-control" placeholder="If this thread is for OOC chat, make sure you say so in the title!" autofocus MaxLength="100"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvThreadTitle" SetFocusOnError="true" runat="server" ErrorMessage="A title is required." ControlToValidate="txtThreadTitle" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
    </asp:Panel>
    <asp:Panel ID="pnlMyCharacters" runat="server" ClientIDMode="Static" CssClass="SelectableCharacterList MyCharactersForThread">
        <label runat="server" id="lblMyCharacters" for="rblMyCharacters">Create Thread As...</label>
        <asp:RadioButtonList ID="rblMyCharacters" runat="server" DataSourceID="sdsMyCharacters" DataTextField="CharacterDisplayName" DataValueField="CharacterID" RepeatLayout="UnorderedList"></asp:RadioButtonList>
        <asp:SqlDataSource ID="sdsMyCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterDisplayName], [CharacterID] FROM [Characters] WHERE ([UserID] = @UserID) And CharacterStatusID = 1 ORDER BY [CharacterID]">
            <SelectParameters>
                <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </asp:Panel>
    <asp:Panel ID="pnlOtherCharacter" runat="server" CssClass="form-group">
        <label>Other Characters</label><br />
        <a href="#" class="btn btn-default" data-toggle="modal" data-target="#UserSearch">Add Characters</a>
        <a href="#" class="btn btn-danger" data-toggle="modal" data-target="#RemoveCharacters">Remove Characters</a>
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
                <div class="ThreadUsers">
                    <asp:Literal ID="litRecipientList" runat="server"></asp:Literal>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnAddCharacters" />
                <asp:AsyncPostBackTrigger ControlID="btnRemoveCharacters" />
            </Triggers>
        </asp:UpdatePanel>
    </asp:Panel>
    <div class="alert alert-notice small"><strong>Please Note:</strong> No one has any obligation to respond to your threads. While some people could be more well mannered and explain why they're not interested in pursuing a Role-Play or Conversation, others may not be so inclined and simply leave without a notice. Pursuing any of these people further will be considered harassment and may result in punishment.</div>

    <asp:Panel ID="pnlContentPostArea" runat="server" DefaultButton="btnCreateThread">
        <div class="form-group">
            <label for="txtPostContent">Post Content</label>
            <asp:TextBox ID="txtPostContent" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="The post content goes here..." Rows="12" ValidateRequestMode="Disabled"></asp:TextBox>
            <%--<asp:RequiredFieldValidator ID="rfvPostContent" SetFocusOnError="true" runat="server" ErrorMessage="You can't create blank messages." ControlToValidate="txtPostContent" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>--%>
        </div>
        <div class="ButtonPanel clearfix">
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                <asp:LinkButton ID="btnCreateThread" runat="server" Text="Create Thread" CssClass="btn btn-primary" OnClientClick="deactivateButton(this);" OnClick="btnCreateThread_Click" />
            </div>
        </div>
    </asp:Panel>
</asp:Panel>
<asp:Panel runat="server" ClientIDMode="Static" DefaultButton="btnUserSearch" CssClass="modal fade" ID="UserSearch" TabIndex="-1" role="dialog" aria-labelledby="UserSearchLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="UserSearchLabel">Find Characters</h4>
            </div>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="modal-body">
                        <p>You can find characters by their display name, first, middle or last name, or their ID number.</p>
                        <p>If you want to add more of your own characters, you'll have to do so <strong>after</strong> the thread is created.</p>
                        <div class="form-inline">
                            <div class="form-group">
                                <label class="sr-only" for="txtUserSearch">Search For Characters</label>
                                <asp:TextBox ID="txtUserSearch" runat="server" CssClass="form-control" placeholder="Type your search here." ValidationGroup="UserSearch"></asp:TextBox>
                            </div>
                            <asp:Button ID="btnUserSearch" runat="server" Text="Find Characters" CssClass="btn btn-default" OnClick="btnUserSearch_Click" ValidationGroup="UserSearch" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvUserSearch" SetFocusOnError="true" runat="server" ErrorMessage="You must enter something to search for." ControlToValidate="txtUserSearch" Display="Dynamic" CssClass="label label-danger" ValidationGroup="UserSearch"></asp:RequiredFieldValidator>
                        <script type="text/javascript">
                            Sys.Application.add_load(BindEvents);
                            function BindEvents() {
                                $('[data-toggle=tooltip]').tooltip();
                            }
                        </script>
                        <asp:Panel ID="pnlSearchResults" runat="server" class="SelectableCharacterList UserSearchResults" Visible="false">
                            <asp:CheckBoxList ID="cblUserSearchResults" runat="server" RepeatLayout="UnorderedList">
                            </asp:CheckBoxList>
                        </asp:Panel>

                        <asp:Panel ID="pnlSearchMessage" runat="server" CssClass="alert alert-info" Visible="false">
                            <asp:Literal ID="litSearchMessage" runat="server"></asp:Literal>
                        </asp:Panel>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnAddCharacters" runat="server" Text="Add Characters" Visible="false" CssClass="btn btn-primary" OnClientClick="Closepopup(); return true;" ValidationGroup="SelectUsers" OnClick="btnAddCharacters_Click" />
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnUserSearch" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Panel>
<asp:Panel runat="server" ClientIDMode="Static" DefaultButton="btnRemoveCharacters" CssClass="modal fade" ID="RemoveCharacters" TabIndex="-1" role="dialog" aria-labelledby="RemoveCharactersLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="RemoveCharactersLabel">Find Characters</h4>
            </div>
            <div class="modal-body">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                    <ContentTemplate>
                        <p>Here are all the currently included characters (excluding your own). Please select the characters you would like to remove.</p>
                        <script type="text/javascript">
                            Sys.Application.add_load(BindEvents);
                            function BindEvents() {
                                $('[data-toggle=tooltip]').tooltip();
                            }
                        </script>
                        <asp:Panel ID="pnlRemoveableCharacters" runat="server" class="SelectableCharacterList RemovableCharacters">
                            <asp:CheckBoxList ID="cblRemoveableCharacters" runat="server" RepeatLayout="UnorderedList">
                            </asp:CheckBoxList>
                            <asp:Button ID="btnRemoveCharacters" runat="server" Text="Remove Characters" CssClass="btn btn-danger" OnClientClick="Closeotherpopup(); return true;" OnClick="btnRemoveCharacters_Click" />
                        </asp:Panel>

                        <asp:Panel ID="pnlRemoveMessage" runat="server" CssClass="alert alert-info" Visible="false">
                            <asp:Literal ID="litRemoveMessage" runat="server"></asp:Literal>
                        </asp:Panel>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddCharacters" />
                        <asp:AsyncPostBackTrigger ControlID="btnRemoveCharacters" />
                    </Triggers>
                </asp:UpdatePanel>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</asp:Panel>
