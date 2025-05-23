<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SendAsChanger.ascx.cs" Inherits="RolePlayersGuild.templates.controls.SendAsChanger" %>
<asp:UpdatePanel ID="upChangeCharacters" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="rptMyCharacters" EventName="ItemCommand" />
    </Triggers>
    <ContentTemplate>
        <a runat="server" id="aSendAs" href="#" data-toggle="modal" data-target="#MyCharacters" class="CharacterImage">
            <asp:HiddenField ID="hdnCharacterDisplayName" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnCharacterNameClass" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnCharacterThumbnail" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnCurrentCharacterID" runat="server" ClientIDMode="Static" />
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upChangeCharacters">
                <ProgressTemplate>
                    <span class="UpdateProgress"><img src="/Images/Icons/spin.gif" /></span>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </a>
        <div class="modal fade" id="MyCharacters" tabindex="-1" role="dialog" aria-labelledby="MyCharactersLabel">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="MyCharactersLabel">Switch To...</h4>
                    </div>
                    <div class="modal-body SwitchToCharacterList">
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Repeater ID="rptMyCharacters" runat="server" DataSourceID="sdsMyCharacters" OnItemDataBound="rptMyCharacters_ItemDataBound" OnItemCommand="rptMyCharacters_ItemCommand">
                                    <ItemTemplate>
                                        <asp:Button ID="btnCharacter" runat="server" Text="Switch To..." CssClass="btn btn-primary btn-sm" formnovalidate />
                                    </ItemTemplate>
                                </asp:Repeater>

                                <asp:SqlDataSource ID="sdsMyCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterDisplayName], [CharacterID] FROM [Characters] WHERE ([UserID] = @UserID) AND CharacterStatusID = 1 ORDER BY [CharacterID]">
                                    <SelectParameters>
                                        <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
